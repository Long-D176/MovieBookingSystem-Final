#!/usr/bin/env bash
set -euo pipefail

NGINX_SITE="/etc/nginx/sites-available/moviebooking-final"
BACKUP_SITE="/etc/nginx/sites-available/moviebooking-final.compose.bak"

if [[ ! -f "$BACKUP_SITE" ]]; then
  echo "Backup file not found: $BACKUP_SITE" >&2
  exit 1
fi

sudo cp "$BACKUP_SITE" "$NGINX_SITE"
sudo nginx -t
sudo systemctl reload nginx

echo "Nginx has been restored to the Docker Compose upstreams."
