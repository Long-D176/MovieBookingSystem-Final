#!/usr/bin/env bash
set -euo pipefail

DEPLOY_MODE="${DEPLOY_MODE:-auto}"
COMPOSE_FILE="${COMPOSE_FILE:-deploy/docker-compose.prod.yml}"
ENV_FILE="${ENV_FILE:-deploy/.env.production}"
K8S_NAMESPACE="${K8S_NAMESPACE:-moviebooking}"
K8S_APP_NODEPORT="${K8S_APP_NODEPORT:-30080}"
K8S_GRAFANA_NODEPORT="${K8S_GRAFANA_NODEPORT:-30081}"
APP_DOMAIN="${APP_DOMAIN:-tungtungtungtungsahur.site}"
GRAFANA_DOMAIN="${GRAFANA_DOMAIN:-grafana.tungtungtungtungsahur.site}"

compose() {
  docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" "$@"
}

kctl() {
  sudo k3s kubectl "$@"
}

require_file() {
  local path="$1"
  if [[ ! -f "$path" ]]; then
    echo "Missing required file: $path" >&2
    exit 1
  fi
}

check_http() {
  local label="$1"
  local url="$2"
  echo "Checking ${label}: ${url}"
  curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --retry 6 \
    --retry-delay 5 \
    --retry-all-errors \
    "$url" > /dev/null
  echo "OK: ${label}"
}

detect_mode() {
  if [[ "$DEPLOY_MODE" != "auto" ]]; then
    return
  fi

  if command -v k3s >/dev/null 2>&1 && kctl get namespace "$K8S_NAMESPACE" >/dev/null 2>&1; then
    DEPLOY_MODE="k8s"
  else
    DEPLOY_MODE="compose"
  fi
}

print_target_jobs() {
  python3 -c "import json, sys; payload=json.load(sys.stdin); jobs=sorted({target['labels'].get('job','unknown') for target in payload['data']['activeTargets'] if target.get('health') == 'up'}); print(', '.join(jobs))"
}

detect_mode

echo "Detected deploy mode: ${DEPLOY_MODE}"
echo

if [[ "$DEPLOY_MODE" == "k8s" ]]; then
  echo "== Kubernetes workloads =="
  kctl -n "$K8S_NAMESPACE" get pods,svc,pvc
  echo

  echo "== Local NodePort checks =="
  curl --fail --silent --show-error "http://127.0.0.1:${K8S_APP_NODEPORT}" > /dev/null
  echo "OK: App NodePort ready"

  curl --fail --silent --show-error "http://127.0.0.1:${K8S_GRAFANA_NODEPORT}/api/health"
  echo

  echo "== Public checks =="
  check_http "Public app" "https://${APP_DOMAIN}"
  check_http "Admin dashboard redirect target" "https://${APP_DOMAIN}/admin"
  check_http "Adminer" "https://${APP_DOMAIN}/adminer/"
  check_http "Grafana" "https://${GRAFANA_DOMAIN}/api/health"

  echo
  echo "== Prometheus active targets =="
  kctl -n "$K8S_NAMESPACE" exec deploy/prometheus -- wget -qO- http://localhost:9090/api/v1/targets | print_target_jobs
else
  require_file "$COMPOSE_FILE"
  require_file "$ENV_FILE"

  echo "== Compose services =="
  compose ps
  echo

  echo "== Local monitoring checks =="
  curl --fail --silent --show-error http://127.0.0.1:9090/-/ready > /dev/null
  echo "OK: Prometheus ready"

  curl --fail --silent --show-error http://127.0.0.1:3001/api/health
  echo

  echo "== Public checks =="
  check_http "Public app" "https://${APP_DOMAIN}"
  check_http "Admin dashboard redirect target" "https://${APP_DOMAIN}/admin"
  check_http "Adminer" "https://${APP_DOMAIN}/adminer/"
  check_http "Grafana" "https://${GRAFANA_DOMAIN}/api/health"

  echo
  echo "== Prometheus active targets =="
  curl --fail --silent --show-error http://127.0.0.1:9090/api/v1/targets | print_target_jobs
fi

echo
echo "Preflight completed successfully."
