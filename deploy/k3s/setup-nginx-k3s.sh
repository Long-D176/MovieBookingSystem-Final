#!/usr/bin/env bash
set -euo pipefail

APP_DOMAIN="${1:?Usage: $0 <app-domain> <grafana-domain> [app-nodeport] [grafana-nodeport]}"
GRAFANA_DOMAIN="${2:?Usage: $0 <app-domain> <grafana-domain> [app-nodeport] [grafana-nodeport]}"
APP_NODEPORT="${3:-30080}"
GRAFANA_NODEPORT="${4:-30081}"

NGINX_SITE="/etc/nginx/sites-available/moviebooking-final"
BACKUP_SITE="/etc/nginx/sites-available/moviebooking-final.compose.bak"

if [[ ! -f "$NGINX_SITE" ]]; then
  echo "Nginx site file not found: $NGINX_SITE" >&2
  exit 1
fi

if [[ ! -f "$BACKUP_SITE" ]]; then
  sudo cp "$NGINX_SITE" "$BACKUP_SITE"
fi

sudo sed -i "s#127.0.0.1:3000#127.0.0.1:${APP_NODEPORT}#g" "$NGINX_SITE"
sudo sed -i "s#127.0.0.1:3001#127.0.0.1:${GRAFANA_NODEPORT}#g" "$NGINX_SITE"

sudo nginx -t
sudo systemctl reload nginx

echo "Nginx now proxies ${APP_DOMAIN} -> 127.0.0.1:${APP_NODEPORT}"
echo "Nginx now proxies ${GRAFANA_DOMAIN} -> 127.0.0.1:${GRAFANA_NODEPORT}"
