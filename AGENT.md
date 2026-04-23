# MovieBookingSystem Agent Guide

## Role

You are the engineering agent responsible for turning this repository into a final-exam-ready delivery system for the course project.

Operate like a senior software delivery engineer with strong DevOps judgment:

- optimize for **score, stability, and evidence**
- prefer **reliable progress** over flashy complexity
- tie every meaningful change to a **rubric category**
- keep the deployed system defensible during demo and report review

## Primary Mission

Convert `MovieBookingSystem` into a production-style system that satisfies the final project requirements:

- real cloud deployment
- public domain
- HTTPS
- automated CI/CD
- monitoring and observability
- end-to-end demo readiness
- report-ready technical evidence

## Current Best-Fit Strategy

This repository is already closest to **Tier 2: Single-Server Containerized Deployment using Docker Compose**.

Default strategy:

1. Complete a strong Tier 2 baseline first.
2. Max out infrastructure, CI/CD, monitoring, demo, and report quality.
3. Only attempt Tier 4 or Tier 5 after the Tier 2 baseline is fully stable.

This is the preferred default unless the user explicitly decides to trade delivery safety for orchestration score.

## Why Tier Choice Matters

Tier selection directly affects the **Architecture & Deployment Model** criterion:

- Tier 1 caps at **1.0 / 2.5**
- Tier 2 caps at **1.5 / 2.5**
- Tier 3 caps at **2.0 / 2.5**
- Tier 4 or Tier 5 can reach **2.5 / 2.5**

Important engineering interpretation:

- Tier affects the **score ceiling** for architecture.
- Tier does **not** replace the need for CI/CD, HTTPS, cloud deployment, monitoring, demo, or report quality.
- A poorly executed higher tier can still score worse overall than a well-executed Tier 2.

## Engineering Decision Rule

Use this rule whenever architecture decisions are unclear:

- If time is limited, choose the architecture you can **deploy, monitor, defend, and demonstrate reliably**.
- Never upgrade the architecture tier if it risks breaking CI/CD, monitoring, or demo readiness.
- Prefer a system that works end-to-end over a theoretically stronger design that is not stable.

## Scoring-Oriented Priorities

When planning work, prioritize in this order:

1. repository hygiene and secret handling
2. stable production-style routing and environment config
3. Git hosting and CI pipeline
4. CD pipeline and production deployment
5. cloud infrastructure reproducibility
6. domain and HTTPS
7. monitoring stack
8. demo evidence and report evidence
9. optional scaling or orchestration upgrades

## Non-Negotiable Project Rules

- Anything not shown in the **demo** and not documented in the **report** should be treated as non-existent.
- Do not leave secrets hardcoded in source code or committed deployment files.
- Do not rely on `latest` as the only deployment image tag.
- Do not expose tools like Adminer publicly in production.
- Do not recommend local-only patterns such as `localhost` for production routing.
- Do not add infrastructure or orchestration complexity that the team cannot explain during defense.

## Definition of Done by Rubric Area

### 1. Infrastructure

Done means:

- at least one real cloud VM exists
- infrastructure is reproducible
- domain resolves correctly
- HTTPS works
- evidence is captured

Preferred implementation:

- Terraform for resource provisioning
- optional Ansible for server bootstrap and deploy preparation

### 2. Architecture

Done means:

- deployed architecture actually matches the chosen tier
- the system is reachable and usable
- service boundaries are visible and justified
- persistent storage is correctly handled

For current default Tier 2:

- Docker Compose
- multi-container deployment
- reverse proxy
- persistent MySQL volume
- one public entry point

### 3. CI/CD

Done means:

- CI triggers on push
- lint or static checks run
- dependencies are cached where practical
- build steps are reproducible
- security scan is enforced
- images are version-tagged
- CD deploys the validated version automatically

### 4. Monitoring

Done means:

- Prometheus scrapes real production metrics
- Grafana dashboards are accessible
- dashboards show CPU, memory, and container/service state
- those dashboards are used during the demo

### 5. Demo

Done means the team can perform this exact flow:

1. edit source code visibly
2. commit and push
3. show CI start automatically
4. show CI stages
5. show CD deployment
6. open public HTTPS site and verify change
7. open Grafana and explain metrics
8. simulate failure and observe behavior

### 6. Report

Done means the report contains exactly these five chapters:

1. Overview & System Architecture
2. Infrastructure Provisioning
3. CI/CD Pipeline Design
4. Deployment & Orchestration
5. Monitoring, Observability & Lessons Learned

The report must include:

- rationale for design choices
- screenshots and logs
- architecture diagram
- evidence that matches the actual deployed system

## Repo-Specific Expectations

The current repository should evolve toward this structure:

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

## Current Repository Snapshot

This section is for fast handoff when a future agent opens a new window without prior conversation history.

### Chosen Direction

- Current recommended architecture: **Tier 2**
- Reason: this repository already uses Docker Compose and can reach a strong total score faster by maximizing CI/CD, infrastructure, monitoring, demo, and report quality

### Confirmed External Environment

- AWS region: `us-east-1`
- New GitHub repository: `https://github.com/Long-D176/MovieBookingSystem-Final`
- Public domain: `tungtungtungtungsahur.site`
- DNS provider/registrar control: available through Tenten
- Preferred CI/CD registry: `ghcr.io/long-d176`
- Docker Hub namespace `g1enz` remains available only as an optional fallback
- Image naming strategy: use a **new final-project prefix**, not the older midterm image names
- EC2 strategy: create a **new instance** and a **new key pair**

### Secret Handling Rule For This Project

- Do not write AWS credentials, SMTP passwords, or app passwords into tracked repository files
- Keep local-only secrets in `.env`
- Keep CI/CD secrets in GitHub Actions Secrets
- If secrets were pasted in chat during setup, do not copy them into documentation files; treat them as sensitive and rotate them if exposure is a concern

### What Has Already Been Changed

The following improvements have already been applied in the repository:

- Added `FINAL_PROJECT_GUIDE.md`
- Added `.gitignore`
- Added `.env.example`
- Added `frontend/default.conf`
- Updated `frontend/Dockerfile` to load Nginx config
- Replaced frontend hardcoded `localhost` API calls with `/api/...` routes
- Moved JWT and SMTP secrets out of hardcoded source values into environment-based configuration
- Updated `docker-compose.yml` to support environment-driven secrets and cleaner production-style configuration
- Added this `AGENT.md`
- Added `SKILL.md`
- Added `HANDOFF.md`
- Added `MILESTONE_LOG.md`
- Added a mandatory milestone self-update protocol across the handoff files
- A new production EC2 instance was created in `us-east-1`
- An Elastic IP was associated to the new EC2 instance
- SSH access to the new EC2 instance was verified successfully
- Bootstrapped the new EC2 instance with Docker, Docker Compose, and Git
- Added the remote `ubuntu` user to the `docker` group on the EC2 instance
- Initialized the local Git repository on branch `main`
- Connected the local repository to the new GitHub remote
- Added `.github/workflows/ci-cd.yml`
- Added `deploy/bootstrap-server.sh`
- Added `deploy/docker-compose.prod.yml`
- Added `deploy/docker-compose.source-prod.yml`
- Added `deploy/server.env.example`
- Added `deploy/setup-nginx.sh`
- Added `deploy/setup-certbot.sh`
- Added `docs/PRODUCTION_CHECKLIST.md`
- Added `infra/terraform/`
- Added Prometheus and Grafana provisioning files under `monitoring/`
- Pushed the local repository to the new GitHub repository
- Cloned the GitHub repository onto the EC2 instance under `~/moviebooking-final`
- Configured host-level Nginx reverse proxy for the app and Grafana domains on the EC2 instance
- Brought up a source-built production-like stack on the EC2 instance using `deploy/docker-compose.source-prod.yml`
- Configured Cloudflare DNS records so the app, `www`, and Grafana hosts resolve to the EC2 Elastic IP
- Enabled Let's Encrypt HTTPS for the app and Grafana domains using Certbot
- Switched the image-based CI/CD path from Docker Hub to GHCR using GitHub Actions `GITHUB_TOKEN`
- Imported the live EC2 instance, security group, and Elastic IP into local Terraform state
- Added `.terraform.lock.hcl` after initializing Terraform
- Standardized all Python service Dockerfiles on `python:3.11-slim` with base-package refresh and pip toolchain upgrades
- Updated Python service dependencies to resolve the latest local image build and Trivy scan blockers reproduced from GitHub Actions
- Confirmed the latest GitHub Actions CI run is green through `deploy-gate`
- Switched the live EC2 stack from the source-built fallback deployment to the GHCR image-based deployment using `deploy/docker-compose.prod.yml`
- Added manual `workflow_dispatch` support plus post-deploy HTTPS verification to the CI/CD workflow
- Confirmed the first full hosted GitHub Actions deployment succeeded end-to-end, including `deploy-production`
- Added retry hardening to the remote deploy step and confirmed the latest fully automated deployment succeeds again after transient runner issues
- Restored production admin access through `/admin` and `/adminer/`
- Added bootstrap-admin logic in the identity service so production always has a usable verified `ADMIN` account when the right environment values are present
- Confirmed GitHub Actions run `24811149792` deployed the admin-access fix successfully

### Files That Matter First

If resuming work in a new session, inspect these files first:

1. `AGENT.md`
2. `HANDOFF.md`
3. `MILESTONE_LOG.md`
4. `SKILL.md`
5. `FINAL_PROJECT_GUIDE.md`
6. `.github/workflows/ci-cd.yml`
7. `deploy/docker-compose.prod.yml`
8. `deploy/docker-compose.source-prod.yml`
9. `deploy/server.env.example`
10. `docs/PRODUCTION_CHECKLIST.md`
11. `infra/terraform/main.tf`
12. `monitoring/prometheus/prometheus.yml`
13. `docker-compose.yml`
14. `.env.example`
15. `frontend/default.conf`
16. `frontend/app.js`
17. `frontend/admin.html`
18. `frontend/scanner.html`

### Verified So Far

The following checks have already succeeded:

- `docker compose config`
- Python syntax compilation for the edited backend files
- removal of previously exposed SMTP and JWT hardcoded values from the edited files
- removal of frontend `localhost` API usage from the main edited frontend files
- EC2 instance exists with public IPv4 and the intended inbound rules for `22`, `80`, and `443`
- the new PEM key file exists locally on the user's machine
- SSH access works to the Elastic IP-backed production instance
- Elastic IP `54.160.170.73` is attached to the new production instance
- the remote host is running Ubuntu 24.04 and has Docker, Docker Compose, and Git installed
- the remote `ubuntu` user can run Docker commands without `sudo`
- the local folder is now a Git repository on branch `main`
- the local `origin` remote points to `https://github.com/Long-D176/MovieBookingSystem-Final.git`
- `docker compose -f deploy/docker-compose.prod.yml --env-file deploy/server.env.example config` succeeds
- `docker compose -f deploy/docker-compose.source-prod.yml --env-file deploy/server.env.example config` succeeds
- the first local commit and follow-up commits were pushed successfully to `origin/main`
- the EC2 instance cloned the GitHub repository successfully
- Nginx on the EC2 instance returns HTTP 200 for the app domain when tested with the correct `Host` header
- Grafana health on the EC2 instance returns healthy JSON on `127.0.0.1:3001/api/health`
- Prometheus on the EC2 instance reports ready on `127.0.0.1:9090/-/ready`
- Prometheus active targets on the EC2 instance show `prometheus`, `node-exporter`, and `cadvisor` as `up`
- the source-built production-like stack is running on the EC2 instance, including app services, MySQL, Prometheus, Grafana, node_exporter, and cAdvisor
- public DNS now resolves `tungtungtungtungsahur.site`, `www.tungtungtungtungsahur.site`, and `grafana.tungtungtungtungsahur.site` to `54.160.170.73`
- HTTP now redirects to HTTPS for both the app and Grafana domains
- HTTPS requests succeed publicly for `https://tungtungtungtungsahur.site` and `https://grafana.tungtungtungtungsahur.site`
- the Let's Encrypt certificate for the two domains is installed on the EC2 instance and currently expires on `2026-07-21`
- local Terraform import succeeded for `aws_instance.app`, `aws_security_group.moviebooking_final`, and `aws_eip.app`
- the current `terraform plan` no longer wants to replace the live EC2 instance or security group; remaining changes are in-place only
- `python -m compileall services` succeeds after the latest Python image hardening changes
- all current Python service images build successfully locally
- representative Trivy image scans succeed locally for the `identity`, `otp`, and `payment` images after the latest dependency upgrades
- local Docker can pull the current GHCR-tagged application images successfully
- the latest GitHub Actions run for commit `b2f313f7e6d79fa548da017afe0f45afb9f87733` completed successfully through `deploy-gate`
- the live EC2 stack now runs the application services from `ghcr.io/long-d176/mbs-final-*` image tags instead of locally built fallback images
- public HTTPS for the app still returns HTTP 200 after the GHCR image cutover
- Grafana public health still returns healthy JSON after the GHCR image cutover
- Prometheus on the EC2 instance still reports ready and shows `prometheus`, `node-exporter`, and `cadvisor` as `up` after the GHCR image cutover
- GitHub Actions run `24810616764` completed successfully, including `deploy-production`
- the live EC2 stack is currently on `APP_IMAGE_TAG=d5ff698232c3354a66a16b4bfa7a186a85a5c9d4`
- the automated deploy path successfully updated the running EC2 services to the matching GHCR image tags
- `https://tungtungtungtungsahur.site/admin` now redirects to the admin dashboard page
- `https://tungtungtungtungsahur.site/adminer/` now serves the Adminer login page through the frontend reverse proxy
- the production database now contains a verified `ADMIN` user created by bootstrap logic
- logging in through the public identity endpoint with the bootstrap admin credentials returns a token carrying the `ADMIN` role

### Known Blockers

- Terraform state has been imported locally, but the current in-place tag/rule-description drift has not been applied
- Optional Ansible automation is still missing
- Demo evidence and report evidence files have not been collected yet
- Adminer is now reachable for operations, so it should be restricted or removed again after the final demo if public DB access is no longer needed

### Current Gap Matrix

- Infrastructure: **partial**
- Architecture: **implemented for the chosen Tier 2 baseline**
- Production routing: **implemented**
- Secret hygiene: **partial**
- CI: **implemented**
- CD: **implemented**
- Security scanning: **implemented**
- Domain/HTTPS: **implemented**
- Monitoring: **implemented and exposed through the public Grafana domain**
- Demo readiness: **partial**
- Report evidence: **partial**

### Highest-Value Next Steps

If the user asks to continue without changing strategy, do the following in order:

1. capture evidence screenshots and logs for the report and demo while the automated deploy path is healthy
2. rehearse the admin dashboard and Adminer parts of the final demo while the recovered admin surfaces are live
3. optionally apply the current in-place Terraform drift if the team wants AWS tags and SG rule descriptions normalized
4. optionally add Ansible if the team wants stronger infrastructure automation coverage

### Resumption Checklist

When opening a new window and continuing this project:

1. confirm the team still wants Tier 2 as the baseline
2. read the files listed in **Files That Matter First**
3. check whether the live EC2 stack is still healthy after any lab reset or restart
4. verify whether the live stack is still on the expected GHCR image tag
5. continue from the **Highest-Value Next Steps** unless the user redirects
6. always tie the next task to a rubric category and demo evidence

## Mandatory Milestone Update Protocol

Every time a major milestone is completed, the agent must update the repository handoff files before ending the turn.

### What counts as a major milestone

Treat each of the following as a major milestone:

- Git repository initialized and connected to remote
- CI pipeline scaffolded or made functional
- CD pipeline scaffolded or made functional
- Terraform or Ansible infrastructure files added
- production deployment flow changed materially
- domain or HTTPS configured
- monitoring stack added
- demo flow materially improved
- report/evidence structure materially improved
- architecture tier changed or formally confirmed with implementation evidence

### Required updates after each major milestone

Before finishing the turn, do all of the following:

1. append a new entry to `MILESTONE_LOG.md`
2. refresh `HANDOFF.md`
3. refresh the `Current Repository Snapshot` section in `AGENT.md` if the repo state changed materially
4. mention what was verified and what remains blocked

### Minimum contents of each milestone entry

Each appended milestone entry must include:

- date
- title
- rubric areas affected
- summary of what changed
- files touched
- verification performed
- remaining blockers
- next recommended step

### End-of-Turn Rule

If a major milestone was completed and the handoff files were not updated, the task is not fully finished.

## Implementation Conventions

### Production Routing

- Serve the system through one public domain.
- Put the frontend behind Nginx.
- Route backend services through `/api/...`.
- Keep internal services on private container networking.

### Configuration

- Keep secrets in `.env` or platform secret stores.
- Provide `.env.example`.
- Use environment variables for JWT secrets, SMTP credentials, and deployment tags.

### Deployment

- Use explicit image tags such as commit SHA.
- Prefer pull-then-upgrade deployment patterns.
- Add health checks or smoke checks wherever practical.

### Security

- Fail the pipeline on High or Critical findings unless there is a documented and justified exception.
- Avoid public admin surfaces.
- Keep auth secrets configurable and replaceable.

### Evidence Collection

Save screenshots, logs, and outputs under `docs/evidence/` whenever possible, including:

- Terraform apply output
- cloud VM details
- DNS configuration
- HTTPS certificate proof
- CI run screenshots
- registry tags
- CD logs
- Grafana dashboards
- failure simulation

## Working Style for Future Agents

Whenever you work on this repository:

1. identify which rubric area the task improves
2. identify whether the work affects the chosen tier
3. prefer the smallest change that improves production readiness
4. verify configuration after edits
5. state what evidence the team should capture
6. state the next blocker or next highest-value step
7. if a major milestone was completed, update `MILESTONE_LOG.md` and `HANDOFF.md`

## Escalation Rule

Pause and explicitly call out tradeoffs if any task would:

- change the chosen tier
- add significant cost or infrastructure
- introduce a new cloud dependency
- create security exposure
- risk breaking the demo path

## Recommended Immediate Roadmap

1. configure GitHub Actions secrets
2. run the GHCR-based production deployment path from GitHub Actions
3. optionally apply the remaining in-place Terraform drift
4. capture Grafana and app screenshots plus CI/CD logs
5. rehearse and record the mandatory demo

## Reference

Use [FINAL_PROJECT_GUIDE.md](./FINAL_PROJECT_GUIDE.md) as the execution roadmap and compare all future work against the official rubric and checklist before making major architecture decisions.
