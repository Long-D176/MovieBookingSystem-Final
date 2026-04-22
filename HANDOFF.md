# Repository Handoff

## Purpose

This file is a short operational handoff for future sessions that do not have the prior chat history.

Read this after `AGENT.md` if you need the fastest possible resume point.

This file must be refreshed after every major milestone. For milestone-by-milestone history, read `MILESTONE_LOG.md`.

## Current Direction

- Selected practical baseline: **Tier 2**
- Strategy: maximize total score through strong CI/CD, infrastructure reproducibility, monitoring, demo quality, and report evidence

## Confirmed Environment Decisions

- AWS region: `us-east-1`
- GitHub repo: `https://github.com/Long-D176/MovieBookingSystem-Final`
- Domain: `tungtungtungtungsahur.site`
- DNS management: available via Tenten
- Docker Hub namespace: `g1enz`
- Image naming: use a new final-project prefix
- Infrastructure path: new EC2 instance and new key pair

Important:

- do not save AWS credentials or SMTP app passwords in tracked files
- use local `.env` and GitHub Secrets instead

## What Has Been Completed

- Final project requirements were audited against the repository
- `FINAL_PROJECT_GUIDE.md` was created
- frontend API calls were moved away from hardcoded `localhost`
- Nginx reverse proxy routes were added through `frontend/default.conf`
- environment-based configuration was introduced for JWT and SMTP secrets
- `.env.example` was added
- `.gitignore` was added
- `AGENT.md` and `SKILL.md` were added
- `HANDOFF.md` was expanded into a durable resume file
- `MILESTONE_LOG.md` was added
- a mandatory milestone self-update protocol was added across the handoff files
- a new EC2 instance for final-project deployment was created in `us-east-1`
- an Elastic IP was associated to the new EC2 instance
- SSH access to the new EC2 instance was verified successfully
- the EC2 instance was bootstrapped with Docker, Docker Compose, and Git
- the remote `ubuntu` user was added to the `docker` group
- this folder was initialized as a Git repository on `main`
- `origin` was set to `https://github.com/Long-D176/MovieBookingSystem-Final`
- `.github/workflows/ci-cd.yml` was added
- `deploy/` production deployment files were added
- `monitoring/` provisioning files for Prometheus and Grafana were added
- `infra/terraform/` was added
- the repository was committed and pushed to `origin/main`
- the EC2 instance cloned the GitHub repository into `~/moviebooking-final`
- Nginx reverse proxy was configured on the EC2 instance for the app and Grafana domains
- a source-built production-like stack was deployed on the EC2 instance

## What Was Verified

- `docker compose config` succeeded
- edited Python files compiled successfully
- edited frontend files no longer use `localhost` API endpoints in the main touched files
- previously exposed SMTP and JWT literals were removed from the edited files
- the new EC2 instance exists with public IPv4
- the attached security group exposes `22` from the user's IP and `80/443` publicly
- the new PEM key file exists locally
- SSH login to the instance via Elastic IP succeeds
- the Elastic IP `54.160.170.73` is attached to the production instance
- the remote host now has Docker, Docker Compose, and Git installed
- the remote `ubuntu` user can run Docker without `sudo`
- `git remote -v` points to `https://github.com/Long-D176/MovieBookingSystem-Final.git`
- `docker compose -f deploy/docker-compose.prod.yml --env-file deploy/server.env.example config` succeeds locally
- `docker compose -f deploy/docker-compose.source-prod.yml --env-file deploy/server.env.example config` succeeds locally
- pushes to `origin/main` succeed from this machine
- the EC2 instance serves the app through Nginx with HTTP 200 when tested using the app domain host header
- Grafana health returns healthy JSON on the EC2 instance
- Prometheus reports ready on the EC2 instance
- Prometheus active targets show `prometheus`, `node-exporter`, and `cadvisor` as `up`
- the running EC2 stack currently includes app services, MySQL, Prometheus, Grafana, node_exporter, and cAdvisor

## What Is Still Missing

- GitHub Actions secrets
- domain DNS changes at Tenten
- HTTPS certificates via Certbot
- Terraform initialization/import/apply against the live AWS resources
- optional Ansible
- first image-based production deployment run from GitHub Actions
- demo evidence folder contents

## Known Environment Constraints

- AWS Learner Lab credentials are temporary and may need to be refreshed before Terraform or AWS CLI actions.
- DNS changes at Tenten must be performed manually by the user.
- The source-built fallback deployment is running now, but the graded CI/CD path still depends on GitHub Actions secrets and Docker Hub publishing.
- cAdvisor had to be pinned to the official `gcr.io/cadvisor/cadvisor:v0.52.1` image because the `ghcr.io/google/cadvisor` tags did not resolve from the EC2 instance during deployment.

## Resume Here

If continuing the project with no further user clarification, do this next:

1. add GitHub Actions secrets for Docker Hub, SSH, database, SMTP, JWT, and domains
2. configure Tenten DNS records for `@` and `grafana`
3. run `deploy/setup-certbot.sh` on the EC2 instance after DNS propagation
4. initialize or import the current AWS resources into Terraform state
5. run the first CI/CD deployment and verify the image-based path

## Important Files

- `AGENT.md`
- `SKILL.md`
- `FINAL_PROJECT_GUIDE.md`
- `MILESTONE_LOG.md`
- `.github/workflows/ci-cd.yml`
- `deploy/docker-compose.prod.yml`
- `deploy/docker-compose.source-prod.yml`
- `deploy/server.env.example`
- `docs/PRODUCTION_CHECKLIST.md`
- `infra/terraform/main.tf`
- `monitoring/prometheus/prometheus.yml`
- `docker-compose.yml`
- `.env.example`
- `frontend/default.conf`
