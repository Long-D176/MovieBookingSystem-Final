# Monitoring Directory

This folder contains observability configuration for the CineWorld system.

## What is inside

- `prometheus/` - Prometheus scrape and monitoring configuration.
- `grafana/` - Grafana dashboards and provisioning files.

## How it works

Prometheus collects metrics from the services and infrastructure. Grafana reads those metrics and visualizes them in dashboards for system health and usage tracking.

## How to use

1. Start the monitoring stack with the deployment setup.
2. Update Prometheus targets when service addresses change.
3. Import or modify Grafana dashboards when metrics or alerts change.
4. Use the dashboards to inspect uptime, traffic, and service health.

## Notes

- Keep dashboard JSON files readable and versioned.
- Update scrape targets whenever ports or hostnames change.
- Use monitoring to validate deployments and troubleshoot incidents.
