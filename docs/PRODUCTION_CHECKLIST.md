# Production Checklist

## GitHub Secrets

Add these repository secrets in GitHub before enabling the deployment workflow:

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
- `ADMIN_BOOTSTRAP_EMAIL` (optional)
- `ADMIN_BOOTSTRAP_PASSWORD` (optional)
- `ADMIN_BOOTSTRAP_FULL_NAME` (optional)
- `APP_DOMAIN`
- `GRAFANA_DOMAIN`
- `GRAFANA_ADMIN_PASSWORD`

Notes:

- `EC2_HOST` should be the Elastic IP `54.160.170.73`
- `EC2_USER` should be `ubuntu`
- `EC2_SSH_KEY` should contain the full contents of the PEM file, including the `BEGIN` and `END` lines
- container publishing now targets GHCR, so the workflow uses the built-in `GITHUB_TOKEN` instead of a separate Docker Hub token
- the workflow now gates deployment automatically, so validate/build/publish can run before secrets exist and the deploy job will only run after all required secrets are configured
- after adding the secrets, you can use **Run workflow** in GitHub Actions because the pipeline now supports manual `workflow_dispatch`
- if the optional bootstrap admin secrets are left blank, production falls back to `SMTP_EMAIL` plus `GRAFANA_ADMIN_PASSWORD` to create a usable admin account automatically
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

Before the demo, run:

```bash
cd ~/moviebooking-final
bash deploy/demo-preflight.sh
```

To simulate a recoverable container failure during the demo:

```bash
cd ~/moviebooking-final
bash deploy/demo-simulate-recovery.sh catalog_service https://tungtungtungtungsahur.site
```

For the chosen Tier 2 setup, this script demonstrates recovery through Docker Compose on the production VM.

## Manual Fallback Deployment

If GitHub Actions secrets are not configured yet, the EC2 instance can still run a production-like build directly from the repository source:

```bash
cd ~/moviebooking-final
cp database/init.sql deploy/database-init.sql
cp deploy/server.env.example deploy/.env.production
# edit deploy/.env.production with the real database, SMTP, JWT, and Grafana values
docker compose -f deploy/docker-compose.source-prod.yml --env-file deploy/.env.production up -d --build
```

## First Production Validation

After DNS, CI/CD, and HTTPS are configured, verify:

- `https://tungtungtungtungsahur.site` loads the app
- `https://tungtungtungtungsahur.site/admin` redirects to the admin dashboard
- `https://tungtungtungtungsahur.site/adminer/` opens Adminer
- `https://grafana.tungtungtungtungsahur.site` loads Grafana
- GitHub Actions pushes versioned Docker images
- the EC2 instance pulls the matching image tag
- Prometheus sees `prometheus`, `node_exporter`, and `cadvisor`
