#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-deploy/docker-compose.prod.yml}"
ENV_FILE="${ENV_FILE:-deploy/.env.production}"
APP_DOMAIN="${APP_DOMAIN:-tungtungtungtungsahur.site}"
TIMEOUT_SECONDS="${TIMEOUT_SECONDS:-90}"
SERVICE_NAME="${1:-}"
CHECK_URL="${2:-https://${APP_DOMAIN}}"

compose() {
  docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" "$@"
}

usage() {
  echo "Usage: $0 <service_name> [check_url]" >&2
  echo "Example: $0 catalog_service https://tungtungtungtungsahur.site" >&2
  exit 1
}

if [[ -z "$SERVICE_NAME" ]]; then
  usage
fi

initial_container_id="$(compose ps -q "$SERVICE_NAME")"
if [[ -z "$initial_container_id" ]]; then
  echo "Could not find a running container for service: $SERVICE_NAME" >&2
  compose ps
  exit 1
fi

restart_count_before="$(docker inspect -f '{{.RestartCount}}' "$initial_container_id")"

echo "Crashing PID 1 inside container ${initial_container_id} for service ${SERVICE_NAME}"
docker exec "$initial_container_id" sh -c 'kill -9 1' > /dev/null 2>&1 || true

deadline=$((SECONDS + TIMEOUT_SECONDS))
while (( SECONDS < deadline )); do
  current_container_id="$(compose ps -q "$SERVICE_NAME")"

  if [[ -z "$current_container_id" ]]; then
    sleep 3
    continue
  fi

  running="$(docker inspect -f '{{.State.Running}}' "$current_container_id" 2>/dev/null || echo false)"
  restart_count_now="$(docker inspect -f '{{.RestartCount}}' "$current_container_id" 2>/dev/null || echo 0)"

  if [[ "$running" == "true" && ( "$current_container_id" != "$initial_container_id" || "$restart_count_now" -gt "$restart_count_before" ) ]]; then
    echo "Service ${SERVICE_NAME} restarted successfully."
    compose ps "$SERVICE_NAME"

    if [[ -n "$CHECK_URL" ]]; then
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
    fi

    echo "Failure simulation and recovery check completed."
    exit 0
  fi

  sleep 3
done

echo "Timed out waiting for ${SERVICE_NAME} to recover." >&2
compose ps "$SERVICE_NAME" || true
exit 1
