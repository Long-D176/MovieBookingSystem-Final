# Production Checklist

## GitHub Secrets

Add these repository secrets in GitHub before enabling the deployment workflow:

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `EC2_HOST`
- `EC2_USER`
- `EC2_SSH_KEY`
- `MYSQL_ROOT_PASSWORD`
- `MYSQL_DATABASE`
- `MYSQL_USER`
- `MYSQL_PASSWORD`
- `SMTP_EMAIL`
- `SMTP_PASSWORD`
- `JWT_SECRET`
- `APP_DOMAIN`
- `GRAFANA_DOMAIN`
- `GRAFANA_ADMIN_PASSWORD`

Notes:

- `EC2_HOST` should be the Elastic IP `54.160.170.73`
- `EC2_USER` should be `ubuntu`
- `EC2_SSH_KEY` should contain the full contents of the PEM file, including the `BEGIN` and `END` lines
- keep all secret values out of tracked files

## Tenten DNS

Create these DNS records:

- `A` record for `@` -> `54.160.170.73`
- `A` record for `grafana` -> `54.160.170.73`

Wait for DNS propagation before requesting HTTPS certificates.

## Server Commands

After the first production deployment is running on the EC2 instance:

```bash
cd ~/moviebooking-final
bash deploy/setup-nginx.sh tungtungtungtungsahur.site grafana.tungtungtungtungsahur.site
bash deploy/setup-certbot.sh tungtungtungtungsahur.site grafana.tungtungtungtungsahur.site your-email@example.com
```

## First Production Validation

After DNS, CI/CD, and HTTPS are configured, verify:

- `https://tungtungtungtungsahur.site` loads the app
- `https://grafana.tungtungtungtungsahur.site` loads Grafana
- GitHub Actions pushes versioned Docker images
- the EC2 instance pulls the matching image tag
- Prometheus sees `prometheus`, `node_exporter`, and `cadvisor`
