# Demo Runbook

## Goal

Use this runbook to demonstrate the production system without relying on memory during the final exam.

## Recommended Open Tabs

- GitHub repository main page
- GitHub Actions `CI-CD` workflow
- `https://tungtungtungtungsahur.site`
- `https://tungtungtungtungsahur.site/admin`
- `https://tungtungtungtungsahur.site/adminer/`
- `https://grafana.tungtungtungtungsahur.site`
- AWS EC2 instance page

## Pre-Demo Server Check

SSH into the EC2 host and run:

```bash
cd ~/moviebooking-final
bash deploy/demo-preflight.sh
```

This verifies:

- production containers are running
- public HTTPS is responding
- admin dashboard route is reachable
- Adminer is reachable
- Grafana is healthy
- Prometheus targets are up

## Suggested Demo Flow

1. Show the live public app over HTTPS.
2. Show the admin dashboard route and log in with the bootstrap admin account.
3. Show Adminer access with the production MySQL credentials.
4. Show Grafana and explain the dashboard panels.
5. Make a small visible code change.
6. Commit and push to `main`.
7. Open GitHub Actions and show:
   - validate
   - build and publish
   - deploy gate
   - deploy production
8. Refresh the public site and confirm the change is live.
9. SSH into the server and run the failure simulation command.
10. Refresh Grafana or rerun the preflight script to show recovery.

## Failure Simulation Command

From the EC2 host:

```bash
cd ~/moviebooking-final
bash deploy/demo-simulate-recovery.sh catalog_service https://tungtungtungtungsahur.site
```

You can replace `catalog_service` with another production service if you want to demonstrate recovery on a different container.

## Admin Access Notes

- Admin dashboard login currently works with the bootstrap admin account created by the identity service.
- If no dedicated bootstrap secrets are set, production falls back to:
  - admin email = `SMTP_EMAIL`
  - admin password = `GRAFANA_ADMIN_PASSWORD`

## Evidence To Capture During Rehearsal

- GitHub Actions run showing full success
- Public app over HTTPS
- Admin dashboard login success
- Adminer login success
- Grafana dashboard
- Preflight output
- Failure simulation output showing container recovery
