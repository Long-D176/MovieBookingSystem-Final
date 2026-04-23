# Milestone Log

## Purpose

This file records major project milestones so a future agent can resume work without relying on prior chat history.

Append a new entry every time a major milestone is completed.

## Update Rule

After each major milestone, the agent must:

1. append a new milestone entry here
2. refresh `HANDOFF.md`
3. refresh the current snapshot in `AGENT.md` if the repo state changed materially

## Entry Template

Copy this template for every new milestone:

```md
## [YYYY-MM-DD] Milestone Title

- Summary:
- Rubric areas affected:
- Files touched:
- Verification performed:
- Remaining blockers:
- Next recommended step:
```

## Milestones

## [2026-04-22] Repository audit and handoff foundation

- Summary: Audited the final project specification, checklist, and rubric against the current repository; identified Tier 2 as the strongest practical baseline; improved production-readiness guidance and created durable handoff files.
- Rubric areas affected: architecture, infrastructure planning, CI/CD planning, monitoring planning, demo readiness, report readiness
- Files touched: `FINAL_PROJECT_GUIDE.md`, `docker-compose.yml`, `.env.example`, `.gitignore`, `frontend/Dockerfile`, `frontend/default.conf`, `frontend/app.js`, `frontend/admin.html`, `frontend/scanner.html`, `services/identity/utils.py`, `services/booking/main.py`, `services/management/main.py`, `services/otp/main.py`, `services/payment/main.py`, `AGENT.md`, `SKILL.md`, `HANDOFF.md`
- Verification performed: `docker compose config` succeeded; edited Python files compiled successfully; checked that edited frontend files no longer used hardcoded `localhost` API routes; checked that edited files no longer contained the previously exposed SMTP and JWT literals
- Remaining blockers: repository is not yet a Git repo; Docker daemon was not running for container build verification; no CI/CD files yet; no infrastructure files yet; no monitoring stack yet; no domain or HTTPS yet
- Next recommended step: initialize Git and connect the repository to GitHub, then scaffold `.github/workflows` for CI

## [2026-04-22] Milestone self-update protocol added

- Summary: Added a mandatory milestone logging and handoff refresh protocol so future agents must update the repository state after every major milestone.
- Rubric areas affected: demo readiness, report readiness, project continuity, operational handoff quality
- Files touched: `AGENT.md`, `SKILL.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: reviewed the updated handoff files and confirmed they now reference each other consistently and define a resume flow for new sessions
- Remaining blockers: future milestones still depend on agents actually following the protocol; no Git/CI/infra/monitoring work has been completed yet
- Next recommended step: when the next major engineering milestone is finished, append a new milestone entry and refresh `HANDOFF.md` as part of the same turn

## [2026-04-22] Deployment environment decisions captured

- Summary: Captured the confirmed external environment for the final project, including AWS region, new GitHub repository, public domain, Docker Hub namespace, and the decision to use a new EC2 instance with a new key pair.
- Rubric areas affected: infrastructure planning, deployment planning, CI/CD planning, demo readiness
- Files touched: `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: reviewed the new handoff notes to ensure the region, domain, GitHub repo, and Docker Hub namespace are recorded without storing secrets in tracked files
- Remaining blockers: the new EC2 instance has not been created yet; Git is still not connected to the new repository; CI/CD and infrastructure files are still missing
- Next recommended step: create the new EC2 instance using the agreed launch parameters, then connect the local project to the new GitHub repository and scaffold CI

## [2026-04-22] New EC2 instance created for final deployment

- Summary: A new EC2 instance named `moviebooking-final-prod` was created in `us-east-1` with a public IPv4 address, a new key pair, and a security group exposing SSH from the user's current IP plus HTTP/HTTPS publicly.
- Rubric areas affected: infrastructure, deployment readiness, domain/HTTPS preparation
- Files touched: `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: reviewed the AWS console screenshots showing the new instance, confirmed instance type `t3.large`, confirmed public IPv4 assignment, confirmed inbound rules for `22`, `80`, and `443`, and confirmed the local PEM file exists
- Remaining blockers: SSH access has not yet been tested; GitHub repo integration is still pending; CI/CD, Terraform, and monitoring are still missing; domain and HTTPS are not configured yet
- Next recommended step: SSH into the new EC2 instance, bootstrap Docker prerequisites, and then connect the local codebase to the new GitHub repository

## [2026-04-22] Elastic IP association and SSH access verified

- Summary: The new EC2 instance received an Elastic IP and SSH access was verified successfully using the new PEM key from the local Windows machine.
- Rubric areas affected: infrastructure, deployment readiness, domain/HTTPS preparation
- Files touched: `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed Elastic IP association in the AWS console; validated TCP connectivity to port 22; corrected Windows ACLs on the PEM file; successfully ran `whoami`, `hostname`, and `lsb_release -a` over SSH on the remote Ubuntu 24.04 host
- Remaining blockers: server bootstrap is not done yet; GitHub repo integration is still pending; CI/CD, Terraform, monitoring, DNS, and HTTPS are still missing
- Next recommended step: install Docker, Compose support, and Git on the EC2 instance, then connect the local repository to GitHub and scaffold CI

## [2026-04-22] Server bootstrap, Git initialization, and deployment skeleton added

- Summary: Bootstrapped the new EC2 instance with Docker, Docker Compose, and Git; added the `ubuntu` user to the `docker` group; initialized the local Git repository on `main` and connected it to the new GitHub remote; scaffolded GitHub Actions CI/CD, production deployment files, and Prometheus/Grafana provisioning files.
- Rubric areas affected: infrastructure, CI/CD, deployment orchestration, monitoring, demo readiness
- Files touched: `.github/workflows/ci-cd.yml`, `deploy/bootstrap-server.sh`, `deploy/docker-compose.prod.yml`, `deploy/server.env.example`, `monitoring/prometheus/prometheus.yml`, `monitoring/grafana/provisioning/datasources/datasource.yml`, `monitoring/grafana/provisioning/dashboards/dashboard.yml`, `monitoring/grafana/provisioning/dashboards/json/system-overview.json`, `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: verified SSH access to the Elastic IP-backed host; confirmed remote Docker, Docker Compose, and Git versions; confirmed the remote `ubuntu` user can run Docker without `sudo`; confirmed `git remote -v` points to the new GitHub repo; confirmed `docker compose -f deploy/docker-compose.prod.yml --env-file deploy/server.env.example config` succeeds locally
- Remaining blockers: the repository has not been committed and pushed yet; GitHub Actions secrets are not configured; Terraform is still missing; DNS and HTTPS are not configured; the production stack and monitoring stack are not yet running on the EC2 instance
- Next recommended step: make the first commit and push to GitHub, then configure GitHub Actions secrets and the app/grafana DNS records

## [2026-04-22] GitHub push, Terraform scaffold, and live fallback deployment completed

- Summary: Added Terraform files, DNS and secrets checklists, Nginx and Certbot helper scripts, and a source-based production fallback Compose file; committed and pushed the repository to GitHub; cloned the repo onto the EC2 instance; configured Nginx reverse proxy on the EC2 host; and deployed a live production-like stack from source with Prometheus and Grafana running on the server.
- Rubric areas affected: infrastructure, deployment orchestration, CI/CD preparation, monitoring, demo readiness
- Files touched: `.gitignore`, `infra/terraform/versions.tf`, `infra/terraform/variables.tf`, `infra/terraform/main.tf`, `infra/terraform/outputs.tf`, `infra/terraform/terraform.tfvars.example`, `infra/terraform/README.md`, `deploy/setup-nginx.sh`, `deploy/setup-certbot.sh`, `deploy/docker-compose.source-prod.yml`, `deploy/docker-compose.prod.yml`, `docs/PRODUCTION_CHECKLIST.md`, `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed pushes to `origin/main` succeed; confirmed the EC2 instance cloned the GitHub repo; confirmed Nginx returns HTTP 200 for the app with the correct host header; confirmed Grafana health returns healthy JSON; confirmed Prometheus is ready; confirmed Prometheus active targets show `prometheus`, `node-exporter`, and `cadvisor` as `up`; confirmed the live EC2 stack is running app services, MySQL, Prometheus, Grafana, node_exporter, and cAdvisor
- Remaining blockers: GitHub Actions secrets are not configured; DNS and HTTPS are not configured; Terraform has not been initialized or imported against the live AWS resources; the image-based CI/CD deployment path has not been tested yet; demo/report evidence has not been collected yet
- Next recommended step: configure GitHub Actions secrets and Tenten DNS records, then request HTTPS certificates and run the first image-based deployment from GitHub Actions

## [2026-04-22] Public DNS and HTTPS enabled for the production domains

- Summary: Updated Cloudflare DNS so the root, `www`, and `grafana` hosts resolve to the production Elastic IP, then used Certbot with the Nginx plugin to obtain and install Let's Encrypt certificates for the app and Grafana domains.
- Rubric areas affected: infrastructure, domain/HTTPS, deployment readiness, demo readiness
- Files touched: `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed public DNS resolves the three hosts to `54.160.170.73`; confirmed HTTP redirects to HTTPS for both the app and Grafana domains; confirmed public HTTPS requests succeed for `https://tungtungtungtungsahur.site` and `https://grafana.tungtungtungtungsahur.site`; confirmed Let's Encrypt certificate installation succeeded and the certificate currently expires on `2026-07-21`
- Remaining blockers: GitHub Actions secrets are not configured; Terraform has not been initialized or imported against the live AWS resources; the image-based CI/CD deployment path has not been tested; demo/report evidence has not been collected yet
- Next recommended step: configure GitHub Actions secrets, then run the first end-to-end image-based deployment from GitHub Actions and capture evidence

## [2026-04-22] Terraform import completed and CI/CD registry moved to GHCR

- Summary: Installed Terraform locally, initialized the Terraform working directory, imported the live EC2 instance, security group, and Elastic IP into local Terraform state, and updated the image-based CI/CD path to use GHCR through GitHub Actions `GITHUB_TOKEN` instead of a separate Docker Hub token.
- Rubric areas affected: infrastructure reproducibility, CI/CD, deployment readiness
- Files touched: `.github/workflows/ci-cd.yml`, `deploy/docker-compose.prod.yml`, `deploy/server.env.example`, `infra/terraform/variables.tf`, `infra/terraform/main.tf`, `infra/terraform/terraform.tfvars.example`, `infra/terraform/README.md`, `infra/terraform/.terraform.lock.hcl`, `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed Terraform import success for `aws_instance.app`, `aws_security_group.moviebooking_final`, and `aws_eip.app`; confirmed the updated production compose config resolves GHCR image paths correctly; confirmed the current `terraform plan` only proposes in-place updates and no longer wants to replace the live EC2 instance or security group
- Remaining blockers: GitHub Actions secrets are not configured; the GHCR-based CI/CD deployment path has not been executed yet; optional in-place Terraform drift has not been applied; demo/report evidence has not been collected yet
- Next recommended step: add GitHub Actions secrets and run the first GHCR-based CI/CD deployment, then capture screenshots/logs for evidence

## [2026-04-22] Python service image hardening completed for CI scan compatibility

- Summary: Hardened all Python service images after reproducing the latest GitHub Actions failures locally, moving the services to `python:3.11-slim`, refreshing base packages during image build, upgrading pip tooling, and updating FastAPI and auth-related dependencies so local image builds and representative Trivy scans now pass again.
- Rubric areas affected: CI, security scanning, deployment readiness, secret hygiene
- Files touched: `services/booking/Dockerfile`, `services/booking/requirements.txt`, `services/catalog/Dockerfile`, `services/catalog/requirements.txt`, `services/identity/Dockerfile`, `services/identity/requirements.txt`, `services/management/Dockerfile`, `services/management/requirements.txt`, `services/otp/Dockerfile`, `services/otp/requirements.txt`, `services/payment/Dockerfile`, `services/payment/requirements.txt`, `services/redemption/Dockerfile`, `services/redemption/requirements.txt`, `services/scheduler/Dockerfile`, `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed `python -m compileall services` succeeds; built all current Python service images locally; confirmed representative Trivy image scans return clean results for the `identity`, `otp`, and `payment` images after the dependency and base-image updates
- Remaining blockers: the GitHub Actions workflow still needs to be rerun on GitHub to confirm the same fixes clear the hosted CI environment; GitHub Actions secrets are still missing for the deployment half of the pipeline; optional Terraform drift and optional Ansible remain open; demo/report evidence has not been collected yet
- Next recommended step: commit and push the image hardening changes, then rerun the GitHub Actions workflow and confirm the GHCR-based CI path is green before wiring the final deployment secrets

## [2026-04-23] GHCR image-based production stack verified and made live

- Summary: Verified the hardened GHCR image set locally with Docker Desktop, confirmed the latest GitHub Actions CI run passes on GitHub, fast-forwarded the EC2 clone to the latest `main`, and switched the live production stack from the source-built fallback images to the GHCR-based `deploy/docker-compose.prod.yml` stack.
- Rubric areas affected: CI, CD, deployment orchestration, monitoring, demo readiness
- Files touched: `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed Docker Desktop daemon is available locally; confirmed `docker compose -f deploy/docker-compose.prod.yml --env-file <temp-env> config` succeeds locally; confirmed all current GHCR app images pull locally; confirmed GitHub Actions run `24791710334` completed successfully through `deploy-gate`; confirmed the EC2 stack now runs `ghcr.io/long-d176/mbs-final-*` image tags; confirmed public HTTPS app access still returns `200`; confirmed Grafana health remains healthy; confirmed Prometheus remains ready with `prometheus`, `node-exporter`, and `cadvisor` targets `up`
- Remaining blockers: GitHub Actions secrets are still missing, so the hosted `deploy-production` job is skipped instead of executing; optional Terraform drift and optional Ansible remain open; demo/report evidence has not been collected yet
- Next recommended step: add the required GitHub Actions secrets and rerun the workflow so the automated `deploy-production` job executes end-to-end on top of the now-validated GHCR stack

## [2026-04-23] Manual workflow rerun support added for final deploy step

- Summary: Added `workflow_dispatch`, concurrency control, and post-deploy HTTPS verification to the GitHub Actions pipeline so the team can trigger the final production deployment manually after secrets are configured without needing an extra code change commit.
- Rubric areas affected: CI, CD, deployment readiness, demo readiness
- Files touched: `.github/workflows/ci-cd.yml`, `docs/PRODUCTION_CHECKLIST.md`, `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: reviewed the updated workflow conditions to confirm image publishing now runs for both `push` and manual workflow dispatch, confirmed deploy jobs remain gated to `main`, and confirmed the checklist now tells the team to use GitHub's **Run workflow** action after secrets are added
- Remaining blockers: GitHub Actions secrets are still not configured, so the automated `deploy-production` path still cannot be demonstrated end-to-end; optional Terraform drift and optional Ansible remain open; demo/report evidence has not been collected yet
- Next recommended step: add the required GitHub Actions secrets in GitHub, use **Run workflow** on the `CI-CD` workflow, and verify the hosted deploy job completes successfully

## [2026-04-23] Automated GitHub Actions deployment completed successfully

- Summary: Configured the GitHub repository secrets, fixed the final post-deploy verification flake with HTTPS retries, and validated the full hosted pipeline end-to-end so GitHub Actions now builds, publishes, deploys, and verifies the production stack automatically on EC2.
- Rubric areas affected: CI, CD, deployment orchestration, monitoring, demo readiness
- Files touched: `.github/workflows/ci-cd.yml`, `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed GitHub Actions run `24810287874` completed successfully including `deploy-production`; confirmed the EC2 host now uses `APP_IMAGE_TAG=65099d301f25aa11d9193f2341620801aa733d78`; confirmed the running application services are on the matching GHCR image tags; confirmed public HTTPS for the app still returns `200`; confirmed Grafana health remains healthy after the automated deploy
- Remaining blockers: optional Terraform drift and optional Ansible remain open; demo/report evidence has not been collected yet
- Next recommended step: capture evidence for the report/demo and rehearse one final small code-change deployment to demonstrate the CI/CD flow live

## [2026-04-23] Automated deployment stabilized after transient runner issues

- Summary: Hardened the workflow with retry logic for the remote deploy step, retried after a transient GitHub-hosted Buildx failure, and confirmed a fresh fully automated deployment run succeeds again so the latest live EC2 stack now tracks the newest GitHub SHA automatically.
- Rubric areas affected: CI, CD, deployment orchestration, demo readiness
- Files touched: `.github/workflows/ci-cd.yml`, `AGENT.md`, `HANDOFF.md`, `MILESTONE_LOG.md`
- Verification performed: confirmed GitHub Actions run `24810616764` completed successfully including `deploy-production`; confirmed the EC2 host now uses `APP_IMAGE_TAG=d5ff698232c3354a66a16b4bfa7a186a85a5c9d4`; confirmed the running application services are on the matching GHCR image tags; confirmed public HTTPS for the app still returns `200`; confirmed Grafana health remains healthy after the newest automated deploy
- Remaining blockers: optional Terraform drift and optional Ansible remain open; demo/report evidence has not been collected yet
- Next recommended step: capture the final evidence set and rehearse the end-to-end demo using a small visible code change
