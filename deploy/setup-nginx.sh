#!/usr/bin/env bash
set -euo pipefail

APP_DOMAIN="${1:?Usage: $0 <app-domain> <grafana-domain>}"
GRAFANA_DOMAIN="${2:?Usage: $0 <app-domain> <grafana-domain>}"

sudo apt-get update -y
sudo apt-get install -y nginx

sudo tee /etc/nginx/sites-available/moviebooking-final >/dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${APP_DOMAIN};

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}

server {
    listen 80;
    listen [::]:80;
    server_name ${GRAFANA_DOMAIN};

    location / {
        proxy_pass http://127.0.0.1:3001;
        proxy_http_version 1.1;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/moviebooking-final /etc/nginx/sites-enabled/moviebooking-final
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx

echo "Nginx reverse proxy is configured for ${APP_DOMAIN} and ${GRAFANA_DOMAIN}."
