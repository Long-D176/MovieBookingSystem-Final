#!/usr/bin/env bash
set -euo pipefail

COMPOSE_FILE="${COMPOSE_FILE:-deploy/docker-compose.prod.yml}"
ENV_FILE="${ENV_FILE:-deploy/.env.production}"
APP_DOMAIN="${APP_DOMAIN:-tungtungtungtungsahur.site}"
GRAFANA_DOMAIN="${GRAFANA_DOMAIN:-grafana.tungtungtungtungsahur.site}"

compose() {
  docker compose -f "$COMPOSE_FILE" --env-file "$ENV_FILE" "$@"
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
curl --fail --silent --show-error http://127.0.0.1:9090/api/v1/targets | python3 -c "import json, sys; payload=json.load(sys.stdin); jobs=sorted({target['labels'].get('job','unknown') for target in payload['data']['activeTargets'] if target.get('health') == 'up'}); print(', '.join(jobs))"

echo
echo "Preflight completed successfully."
