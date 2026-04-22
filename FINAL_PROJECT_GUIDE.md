# Final Project Guide for `MovieBookingSystem`

## Recommended Target

This repository is already closest to **Tier 2: Single-Server Containerized Deployment (Docker Compose)**.

- Tier 2 is the **fastest and safest path** to complete the final project with this codebase.
- A perfect Tier 2 submission can realistically reach **9.0/10.0** based on the provided rubric.
- If your team wants to chase the full **10.0**, finish the Tier 2 baseline first, then upgrade to **Tier 4 (Docker Swarm)** or **Tier 5 (Kubernetes)**.

## Current Audit

### What already exists

- Multi-service application with clear service separation.
- `docker-compose.yml` already runs the system as containers.
- MySQL uses a persistent volume.
- Frontend, admin dashboard, and scanner are already implemented.
- The project is complex enough for the final exam scenario.

### Main gaps against the rubric

- No Git repository inside this folder right now, so CI/CD is not connected yet.
- No GitHub Actions, GitLab CI, or Jenkins pipeline files.
- No Terraform or Ansible.
- No production cloud deployment files.
- No domain and HTTPS setup.
- No Prometheus or Grafana configuration.
- Frontend was hardcoded to `localhost`, which blocks clean production deployment.
- Secrets were hardcoded in the repository.
- No report/demo evidence structure yet.

## Recommended Score Strategy

### If your goal is the fastest strong submission

Choose **Tier 2** and maximize the other categories:

- Infrastructure: aim for **2.0/2.0** using Terraform plus optional Ansible.
- Architecture: **1.5/2.5** with a strong Docker Compose deployment.
- CI/CD: aim for **2.5/2.5**.
- Monitoring: aim for **1.0/1.0**.
- Demo: aim for **1.0/1.0**.
- Report: aim for **1.0/1.0**.

That path is much more realistic than jumping directly to Kubernetes at the last minute.

### If your goal is maximum score

Do this in two phases:

1. Finish the full Tier 2 baseline first.
2. Upgrade deployment to Swarm or Kubernetes only after CI/CD, HTTPS, and monitoring are already stable.

## What this repository should become

You should evolve this folder toward the structure below:

```text
MovieBookingSystem/
  .github/workflows/
  infra/terraform/
  ansible/
  monitoring/
  deploy/
  docs/evidence/
  frontend/
  services/
  database/
  docker-compose.yml
```

## Practical Build Order

### Phase 1. Stabilize this repository

- Initialize Git in this folder and push it to GitHub.
- Add a `.gitignore`.
- Keep secrets in `.env`, not inside tracked files.
- Make the frontend talk to the backend through one reverse proxy path such as `/api/...`.

### Phase 2. Lock the architecture

For Tier 2, your production architecture should be:

- 1 Ubuntu cloud VM
- Docker Engine + Docker Compose
- Nginx reverse proxy container
- frontend container
- backend microservice containers
- MySQL volume
- domain name pointing to the VM
- HTTPS with Let's Encrypt

The application should be reachable from a single domain such as:

- `https://your-domain.com`

And the backend should be hidden behind proxy routes such as:

- `/api/catalog/...`
- `/api/identity/...`
- `/api/booking/...`

### Phase 3. Add Infrastructure as Code

Minimum recommended stack:

- Terraform for VM, firewall/security group, static IP, DNS-friendly outputs.
- Optional Ansible for Docker install, Compose setup, app deploy, and service bootstrap.

Suggested infrastructure deliverables:

- `infra/terraform/main.tf`
- `infra/terraform/variables.tf`
- `infra/terraform/outputs.tf`
- `ansible/playbook.yml`

### Phase 4. Build CI

Your CI workflow should run automatically on push and include:

- source checkout
- dependency caching
- lint or static checks
- image build
- Trivy scan
- fail on High/Critical findings
- image tagging with commit SHA
- push to Docker Hub or GHCR

Suggested output tags:

- `yourdockerhub/movie-frontend:<git-sha>`
- `yourdockerhub/movie-catalog:<git-sha>`
- `yourdockerhub/movie-identity:<git-sha>`

Never rely only on `latest`.

### Phase 5. Build CD

Your CD workflow should:

- pull the exact image tag built by CI
- update the production Compose file
- deploy automatically over SSH
- restart services in a controlled way
- verify health after deploy

For Tier 2, a strong CD pattern is:

1. CI builds and pushes versioned images.
2. CD SSHes into the server.
3. CD writes the target image tag to `.env` or a deploy file.
4. CD runs `docker compose pull && docker compose up -d`.

### Phase 6. Add monitoring

Minimum required stack:

- Prometheus
- Grafana
- Node Exporter
- cAdvisor

Dashboards must show:

- CPU usage
- memory usage
- container status

For a stronger submission, add:

- Loki for logs
- Alertmanager
- custom app metrics later

### Phase 7. Prepare the mandatory demo

Your demo must follow this exact story:

1. Make a visible source code change.
2. Commit and push to the remote repository.
3. Show CI starting automatically.
4. Show lint, cache, build, scan, and image push.
5. Show CD deploying automatically.
6. Open the public HTTPS domain and verify the change.
7. Open Grafana and explain metrics.
8. Stop one container and show how the system behaves.

## Report Structure

The checklist requires exactly five chapters:

1. Overview & System Architecture
2. Infrastructure Provisioning
3. CI/CD Pipeline Design
4. Deployment & Orchestration
5. Monitoring, Observability & Lessons Learned

For each chapter, include:

- design decision
- implementation evidence
- screenshots/logs
- why the decision matches the chosen architecture tier

## Evidence You Must Collect

Create a folder like `docs/evidence/` and save:

- Terraform apply screenshots or terminal output
- server IP/domain screenshots
- HTTPS certificate screenshot
- GitHub Actions CI run screenshot
- Docker registry image tags screenshot
- CD deployment logs
- Grafana dashboard screenshots
- failure simulation screenshots

## Important Warnings

- Anything not shown in the **demo** and not written in the **report** is treated as non-existent.
- Exposed secrets reduce professionalism and can hurt your defense.
- `localhost`-based frontend URLs are not acceptable for real deployment.
- Adminer should not be publicly exposed in production.

## Suggested Next Steps After This Commit

1. Turn this folder into a Git repo and push it to GitHub.
2. Provision one Ubuntu VM on a real cloud.
3. Buy or connect a domain.
4. Add Terraform and deployment automation.
5. Add GitHub Actions CI/CD.
6. Add Prometheus and Grafana.
7. Rehearse the exact demo flow before recording.
