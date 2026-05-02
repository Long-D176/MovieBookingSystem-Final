# Deployment Directory

This folder contains scripts and deployment templates for local, production, and Kubernetes-based rollout.

## What is inside

- `docker-compose.prod.yml` and `docker-compose.source-prod.yml` - production deployment definitions.
- `bootstrap-server.sh` - server initialization helper.
- `setup-nginx.sh` and `setup-certbot.sh` - web server and certificate setup scripts.
- `demo-*.sh` - scripts for demo, recovery, and preflight checks.
- `k3s/` - Kubernetes/K3s deployment templates and setup scripts.

## How it works

Deployment files automate environment setup so the application can be started consistently across development, demo, and production environments.

## How to use

1. Choose the deployment target you need: local Docker, production Docker, or K3s.
2. Review the scripts before running them on a server.
3. Provide the required environment variables and secrets.
4. Run the deployment script that matches your environment.

## Notes

- Always verify hostnames, ports, and certificates before deploying.
- Review each script before running it on a remote machine.
- Treat production deployment files as operational tooling, not application logic.
