#!/usr/bin/env bash
set -euo pipefail

APP_DOMAIN="${1:?Usage: $0 <app-domain> <grafana-domain> <email>}"
GRAFANA_DOMAIN="${2:?Usage: $0 <app-domain> <grafana-domain> <email>}"
LETSENCRYPT_EMAIL="${3:?Usage: $0 <app-domain> <grafana-domain> <email>}"

sudo apt-get update -y
sudo apt-get install -y certbot python3-certbot-nginx

sudo certbot --nginx \
  --non-interactive \
  --agree-tos \
  --redirect \
  -m "${LETSENCRYPT_EMAIL}" \
  -d "${APP_DOMAIN}" \
  -d "${GRAFANA_DOMAIN}"

sudo systemctl reload nginx

echo "HTTPS certificates were requested for ${APP_DOMAIN} and ${GRAFANA_DOMAIN}."
