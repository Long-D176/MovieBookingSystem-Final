#!/usr/bin/env bash
set -euo pipefail

DEPLOY_MODE="${DEPLOY_MODE:-auto}"
COMPOSE_FILE="${COMPOSE_FILE:-deploy/docker-compose.prod.yml}"
ENV_FILE="${ENV_FILE:-deploy/.env.production}"
K8S_NAMESPACE="${K8S_NAMESPACE:-moviebooking}"
APP_DOMAIN="${APP_DOMAIN:-tungtungtungtungsahur.site}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-90}"
SERVICE_NAME="${1:-}"
CHECK_URL="${2:-https://${APP_DOMAIN}}"

compose() {
  docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" "$@"
}

kctl() {
  sudo k3s kubectl "$@"
}

usage() {
  echo "Usage: $0 <service_name> [check_url]" >&2
  echo "Example (k8s): $0 catalog-service https://tungtungtungtungsahur.site" >&2
  echo "Example (compose): $0 catalog_service https://tungtungtungtungsahur.site" >&2
  exit 1
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

check_public_endpoint() {
  if [[ -z "$CHECK_URL" ]]; then
    return
  fi

  echo "Checking public endpoint after recovery: ${CHECK_URL}"
  curl \
    --fail \
    --silent \
    --show-error \
    --location \
    --retry 6 \
    --retry-delay 5 \
    --retry-all-errors \
    "$CHECK_URL" > /dev/null
  echo "Public endpoint responded successfully."
}

normalize_workload_name() {
  echo "$1" | tr '_' '-'
}

if [[ -z "$SERVICE_NAME" ]]; then
  usage
fi

detect_mode

if [[ "$DEPLOY_MODE" == "k8s" ]]; then
  WORKLOAD_NAME="$(normalize_workload_name "$SERVICE_NAME")"

  if ! kctl -n "$K8S_NAMESPACE" get deployment "$WORKLOAD_NAME" >/dev/null 2>&1; then
    echo "Could not find a deployment named ${WORKLOAD_NAME} in namespace ${K8S_NAMESPACE}" >&2
    kctl -n "$K8S_NAMESPACE" get deployments
    exit 1
  fi

  initial_pod="$(kctl -n "$K8S_NAMESPACE" get pods -l "app=${WORKLOAD_NAME}" -o jsonpath='{.items[0].metadata.name}' 2>/dev/null || true)"
  if [[ -z "$initial_pod" ]]; then
    echo "Could not find a running pod for deployment ${WORKLOAD_NAME}" >&2
    kctl -n "$K8S_NAMESPACE" get pods -l "app=${WORKLOAD_NAME}"
    exit 1
  fi

  echo "Simulating failure by deleting pod ${initial_pod} for deployment ${WORKLOAD_NAME}"
  kctl -n "$K8S_NAMESPACE" delete pod "$initial_pod" --wait=true >/dev/null

  deadline=$((SECONDS + TIMEOUT_SECONDS))
  while (( SECONDS < deadline )); do
    current_pod="$(kctl -n "$K8S_NAMESPACE" get pods -l "app=${WORKLOAD_NAME}" --field-selector=status.phase=Running -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' 2>/dev/null | grep -v "^${initial_pod}$" | head -n 1 || true)"

    if [[ -n "$current_pod" ]]; then
      ready="$(kctl -n "$K8S_NAMESPACE" get pod "$current_pod" -o jsonpath='{.status.containerStatuses[0].ready}' 2>/dev/null || echo false)"
      if [[ "$ready" == "true" ]]; then
        echo "Deployment ${WORKLOAD_NAME} recovered successfully with pod ${current_pod}."
        kctl -n "$K8S_NAMESPACE" get pods -l "app=${WORKLOAD_NAME}"
        check_public_endpoint
        echo "Failure simulation and recovery check completed."
        exit 0
      fi
    fi

    sleep 3
  done

  echo "Timed out waiting for deployment ${WORKLOAD_NAME} to recover." >&2
  kctl -n "$K8S_NAMESPACE" get pods -l "app=${WORKLOAD_NAME}" || true
  exit 1
fi

initial_container_id="$(compose ps -q "$SERVICE_NAME")"
if [[ -z "$initial_container_id" ]]; then
  echo "Could not find a running container for service: $SERVICE_NAME" >&2
  compose ps
  exit 1
fi

echo "Simulating failure by killing container ${initial_container_id} for service ${SERVICE_NAME}"
docker kill "$initial_container_id" > /dev/null || true

failure_deadline=$((SECONDS + 20))
while (( SECONDS < failure_deadline )); do
  current_status="$(docker inspect -f '{{.State.Status}}' "$initial_container_id" 2>/dev/null || echo missing)"
  if [[ "$current_status" != "running" ]]; then
    break
  fi
  sleep 2
done

echo "Recovering service ${SERVICE_NAME} with docker compose up -d"
compose up -d "$SERVICE_NAME"

deadline=$((SECONDS + TIMEOUT_SECONDS))
while (( SECONDS < deadline )); do
  current_container_id="$(compose ps -q "$SERVICE_NAME")"

  if [[ -z "$current_container_id" ]]; then
    sleep 3
    continue
  fi

  running="$(docker inspect -f '{{.State.Running}}' "$current_container_id" 2>/dev/null || echo false)"

  if [[ "$running" == "true" ]]; then
    echo "Service ${SERVICE_NAME} restarted successfully."
    compose ps "$SERVICE_NAME"
    check_public_endpoint
    echo "Failure simulation and recovery check completed."
    exit 0
  fi

  sleep 3
done

echo "Timed out waiting for ${SERVICE_NAME} to recover." >&2
compose ps "$SERVICE_NAME" || true
exit 1
