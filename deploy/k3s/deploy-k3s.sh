#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="${1:-deploy/.env.production}"
K8S_NAMESPACE="${K8S_NAMESPACE:-moviebooking}"
K8S_APP_NODEPORT="${K8S_APP_NODEPORT:-30080}"
K8S_GRAFANA_NODEPORT="${K8S_GRAFANA_NODEPORT:-30081}"
CUTOVER_NGINX="${CUTOVER_NGINX:-false}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing env file: $ENV_FILE" >&2
  exit 1
fi

set -a
source "$ENV_FILE"
set +a

export K8S_NAMESPACE K8S_APP_NODEPORT K8S_GRAFANA_NODEPORT

kctl() {
  sudo k3s kubectl "$@"
}

require_var() {
  local var_name="$1"
  if [[ -z "${!var_name:-}" ]]; then
    echo "Missing required environment variable: $var_name" >&2
    exit 1
  fi
}

for var_name in IMAGE_NAMESPACE IMAGE_PREFIX APP_IMAGE_TAG MYSQL_ROOT_PASSWORD MYSQL_DATABASE MYSQL_USER MYSQL_PASSWORD SMTP_EMAIL SMTP_PASSWORD JWT_SECRET APP_DOMAIN GRAFANA_DOMAIN GRAFANA_ADMIN_PASSWORD; do
  require_var "$var_name"
done

apply_configmaps() {
  kctl -n "$K8S_NAMESPACE" create configmap frontend-nginx-conf \
    --from-file=default.conf="${SCRIPT_DIR}/frontend-default.conf" \
    --dry-run=client -o yaml | kctl apply -f -

  kctl -n "$K8S_NAMESPACE" create configmap prometheus-config \
    --from-file=prometheus.yml="${REPO_ROOT}/monitoring/prometheus/prometheus-k3s.yml" \
    --dry-run=client -o yaml | kctl apply -f -

  kctl -n "$K8S_NAMESPACE" create configmap grafana-datasources \
    --from-file=datasource.yml="${REPO_ROOT}/monitoring/grafana/provisioning/datasources/datasource.yml" \
    --dry-run=client -o yaml | kctl apply -f -

  kctl -n "$K8S_NAMESPACE" create configmap grafana-dashboard-provider \
    --from-file=dashboard.yml="${REPO_ROOT}/monitoring/grafana/provisioning/dashboards/dashboard.yml" \
    --dry-run=client -o yaml | kctl apply -f -

  kctl -n "$K8S_NAMESPACE" create configmap grafana-dashboard-json \
    --from-file=system-overview.json="${REPO_ROOT}/monitoring/grafana/provisioning/dashboards/json/system-overview.json" \
    --dry-run=client -o yaml | kctl apply -f -
}

apply_secrets() {
  kctl -n "$K8S_NAMESPACE" create secret generic app-secrets \
    --from-literal=MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
    --from-literal=MYSQL_DATABASE="$MYSQL_DATABASE" \
    --from-literal=MYSQL_USER="$MYSQL_USER" \
    --from-literal=MYSQL_PASSWORD="$MYSQL_PASSWORD" \
    --from-literal=SMTP_EMAIL="$SMTP_EMAIL" \
    --from-literal=SMTP_PASSWORD="$SMTP_PASSWORD" \
    --from-literal=JWT_SECRET="$JWT_SECRET" \
    --from-literal=ADMIN_BOOTSTRAP_EMAIL="${ADMIN_BOOTSTRAP_EMAIL:-}" \
    --from-literal=ADMIN_BOOTSTRAP_PASSWORD="${ADMIN_BOOTSTRAP_PASSWORD:-}" \
    --from-literal=ADMIN_BOOTSTRAP_FULL_NAME="${ADMIN_BOOTSTRAP_FULL_NAME:-System Administrator}" \
    --from-literal=GRAFANA_ADMIN_PASSWORD="$GRAFANA_ADMIN_PASSWORD" \
    --dry-run=client -o yaml | kctl apply -f -
}

bootstrap_database() {
  if kctl -n "$K8S_NAMESPACE" get configmap db-bootstrap-complete >/dev/null 2>&1; then
    echo "Skipping database bootstrap because marker configmap already exists."
    return
  fi

  local dump_file
  dump_file="$(mktemp)"

  if docker ps --format '{{.Names}}' | grep -q '^deploy-db-1$'; then
    echo "Migrating live Docker Compose database into Kubernetes MySQL."
    docker exec deploy-db-1 sh -c "exec mysqldump --single-transaction --skip-lock-tables --set-gtid-purged=OFF -u root -p\"$MYSQL_ROOT_PASSWORD\" --databases \"$MYSQL_DATABASE\"" > "$dump_file"
  else
    echo "Seeding Kubernetes MySQL from database/init.sql."
    cp "${REPO_ROOT}/database/init.sql" "$dump_file"
  fi

  cat "$dump_file" | kctl -n "$K8S_NAMESPACE" exec -i db-0 -- sh -c "mysql -u root -p\"$MYSQL_ROOT_PASSWORD\""
  rm -f "$dump_file"

  kctl -n "$K8S_NAMESPACE" create configmap db-bootstrap-complete \
    --from-literal=bootstrapped-at="$(date -Iseconds)" \
    --dry-run=client -o yaml | kctl apply -f -
}

wait_for_rollouts() {
  for workload in \
    deployment/adminer \
    deployment/catalog-service \
    deployment/otp-service \
    deployment/identity-service \
    deployment/booking-service \
    deployment/payment-service \
    deployment/redemption-service \
    deployment/management-service \
    deployment/scheduler-service \
    deployment/frontend \
    daemonset/node-exporter \
    daemonset/cadvisor \
    deployment/prometheus \
    deployment/grafana; do
    kctl -n "$K8S_NAMESPACE" rollout status "$workload" --timeout=300s
  done
}

verify_local_endpoints() {
  curl --fail --silent --show-error "http://127.0.0.1:${K8S_APP_NODEPORT}" > /dev/null
  curl --fail --silent --show-error "http://127.0.0.1:${K8S_GRAFANA_NODEPORT}/api/health" > /dev/null
}

echo "Applying database tier..."
envsubst < "${SCRIPT_DIR}/db.yaml.tmpl" | kctl apply -f -
apply_secrets
kctl -n "$K8S_NAMESPACE" rollout status statefulset/db --timeout=300s
bootstrap_database

echo "Applying application and monitoring tier..."
apply_configmaps
envsubst < "${SCRIPT_DIR}/apps.yaml.tmpl" | kctl apply -f -
wait_for_rollouts
verify_local_endpoints

if [[ "$CUTOVER_NGINX" == "true" ]]; then
  "${SCRIPT_DIR}/setup-nginx-k3s.sh" "$APP_DOMAIN" "$GRAFANA_DOMAIN" "$K8S_APP_NODEPORT" "$K8S_GRAFANA_NODEPORT"
fi

echo "k3s deployment completed successfully."
