---
name: moviebooking-final-project
description: Use when working on the MovieBookingSystem final exam project, especially for architecture tier selection, rubric alignment, CI/CD planning, cloud deployment, monitoring setup, demo preparation, technical report evidence, and converting the current Docker Compose microservices app into a defendable production-style submission.
---

# MovieBookingSystem Final Project Skill

## Use This Skill When

Use this skill when the user asks for any of the following:

- choose or compare architecture tiers
- estimate score impact from architecture decisions
- align repo work to the rubric or checklist
- prepare CI/CD, cloud deployment, HTTPS, or monitoring
- plan the mandatory demo
- structure the technical report
- decide what to build next for the final project

## Skill Goal

Help the team maximize final-project score with the least unnecessary risk.

This skill assumes:

- the application is already a working multi-service movie booking system
- the current repository naturally fits **Tier 2**
- the final grade depends not only on implementation, but also on **demo visibility** and **report evidence**

## Core Principle

Do not optimize for complexity. Optimize for:

- delivery confidence
- visible rubric compliance
- reproducibility
- security hygiene
- demo success

A lower tier implemented cleanly with strong CI/CD, monitoring, and evidence is often a better engineering decision than a fragile high tier.

## Tier Decision Matrix

### Tier 1

- Max architecture score: **1.0 / 2.5**
- Choose only if there are severe technical constraints.
- Usually not recommended for this repository.

### Tier 2

- Max architecture score: **1.5 / 2.5**
- Best fit for the current repository.
- Recommended when the goal is the strongest reliable submission in limited time.
- Requires Docker Compose, multi-container separation, persistent volumes, and production-style routing.

### Tier 3

- Max architecture score: **2.0 / 2.5**
- Choose only if the team can reliably manage multiple servers and load balancing.
- Requires more infrastructure complexity and stronger operational control.

### Tier 4

- Max architecture score: **2.5 / 2.5**
- Choose only after Tier 2 concerns are already stable.
- Good option if the team can run Docker Swarm confidently and explain scheduling, replication, and fault tolerance.

### Tier 5

- Max architecture score: **2.5 / 2.5**
- Highest complexity.
- Only choose if the team can deploy and defend Kubernetes concepts clearly.

## Practical Recommendation

Default recommendation for this repository:

1. Complete a professional **Tier 2** submission first.
2. Only then consider upgrading to Tier 4 or Tier 5.

This recommendation is based on engineering economics:

- the repo already uses Docker Compose
- Tier 2 still allows high total score
- most teams lose more points from weak CI/CD or weak demo execution than from staying at Tier 2

## Required Reading Order

When this skill is used, inspect these local materials in this order:

1. `AGENT.md`
2. `FINAL_PROJECT_GUIDE.md`
3. `docker-compose.yml`
4. `.env.example`
5. frontend production routing files
6. CI/CD files if present
7. infrastructure files if present
8. monitoring files if present

If the official PDF specification, checklist, or rubric are available, align advice to them before proposing major architecture changes.

## Resumption Protocol

If there is no conversation history and work must resume from repository files alone:

1. read `AGENT.md` and extract the current direction, gap matrix, blockers, and next steps
2. verify whether the repository is now a Git repo
3. verify whether `.github/workflows`, `infra/terraform`, `monitoring`, or `deploy` now exist
4. compare the repo state with the latest handoff snapshot in `AGENT.md`
5. continue from the highest-value next missing rubric area unless the user explicitly changes priorities

## Standard Workflow

### Step 1. Build a Gap Matrix

Map each major requirement to one of:

- complete
- partial
- missing
- blocked

Use these categories:

- infrastructure
- architecture
- CI
- CD
- security scanning
- domain/HTTPS
- monitoring
- demo readiness
- report evidence

### Step 2. Choose the Lowest-Risk Architecture That Can Be Defended

Use the tier decision matrix and current repo shape.

Reject unnecessary complexity if:

- the team cannot demo it confidently
- it delays CI/CD or monitoring
- it creates unstable infra

### Step 3. Improve Production Readiness First

Prioritize:

1. environment-based configuration
2. one public frontend entry point
3. reverse proxy routing
4. secret hygiene
5. immutable image tagging

### Step 4. Implement the Delivery Backbone

For a strong Tier 2 submission, the backbone should be:

- GitHub repository
- GitHub Actions CI/CD
- Docker registry with explicit tags
- one Ubuntu VM on a real cloud
- Docker Compose production stack
- Nginx
- domain + HTTPS

### Step 5. Add Monitoring

Minimum acceptable monitoring stack:

- Prometheus
- Grafana
- Node Exporter
- cAdvisor

Dashboards must visibly show:

- CPU usage
- memory usage
- service/container state

### Step 6. Plan the Demo and Report Together

Treat demo and report as delivery requirements, not documentation afterthoughts.

Every completed feature should be tied to:

- a future demo step
- a report section
- a screenshot or log artifact

## Output Expectations When Using This Skill

When responding to the user, structure advice around:

1. chosen or recommended tier
2. score impact
3. current status versus rubric
4. what is already done
5. what must be built next
6. what evidence to collect

## CI/CD Expectations

For this skill, a robust pipeline means:

- triggers on push
- lint or static analysis
- dependency caching
- deterministic build
- vulnerability scanning
- fail gate on High/Critical findings
- image build and registry push
- explicit version tags
- automatic production deploy of the validated version

Avoid recommending pipelines that:

- rely on manual artifact copying
- deploy `latest` blindly
- skip security scanning
- cannot show a clear source-to-production chain

## Monitoring Expectations

Do not treat monitoring as installed software only.

Monitoring is considered complete only if:

- metrics are scraping correctly
- dashboards are readable
- the team can explain what the metrics mean
- the dashboards are shown during deployment verification or failure simulation

## Evidence Rules

Always remind the user that a feature counts for grading only if it appears in:

- the demo or live presentation
- and the report

Recommended evidence set:

- CI run screenshots
- security scan results
- registry tags
- deploy logs
- HTTPS proof
- Grafana dashboards
- failure simulation proof

## Milestone Logging Rule

When a major milestone is completed during work on this repository:

1. append an entry to `MILESTONE_LOG.md`
2. refresh `HANDOFF.md`
3. refresh the relevant snapshot content in `AGENT.md` if needed

Major milestones include:

- new CI/CD capability
- new infrastructure capability
- major deployment changes
- monitoring additions
- domain/HTTPS setup
- large handoff or planning improvements

Do not consider the work fully handed off until those files are updated.

## Red Flags

Escalate carefully when you detect any of these:

- hardcoded credentials
- missing Git repository
- no production routing strategy
- no image versioning strategy
- no monitoring path
- a desire to jump to Kubernetes without a stable CI/CD baseline

## Repo-Specific Defaults

For `MovieBookingSystem`, default assumptions are:

- current path is Tier 2 unless the user explicitly changes direction
- frontend should call backend through `/api/...`
- Compose remains the baseline deployment mechanism
- infrastructure and monitoring should be added around the app, not by rewriting the app from scratch
- `AGENT.md` is the primary handoff source for future windows

## Definition of Success

This skill is successful when the team ends up with:

- a real cloud-hosted application
- public HTTPS access
- automated CI/CD
- visible monitoring
- a reliable live demo flow
- a report that exactly matches what was actually deployed

## Local Reference

Use `AGENT.md` for repo-level operating rules, `HANDOFF.md` for short resume state, `MILESTONE_LOG.md` for change history, and `FINAL_PROJECT_GUIDE.md` for the broader execution roadmap.
