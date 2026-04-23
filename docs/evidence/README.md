# Evidence Checklist

Capture these artifacts before recording the final video and writing the report.

## Infrastructure

- AWS EC2 instance details
- Elastic IP association
- Security group inbound rules
- Terraform plan or state evidence

## DNS and HTTPS

- Cloudflare DNS records for `@`, `www`, and `grafana`
- Browser certificate view for `tungtungtungtungsahur.site`
- Browser certificate view for `grafana.tungtungtungtungsahur.site`

## CI/CD

- GitHub Actions run list
- One full successful `CI-CD` run
- GHCR packages/tags page
- Deploy job success log

## Application and Operations

- Public home page over HTTPS
- Admin dashboard login success
- Adminer login success
- `docker compose ps` on the EC2 host
- `bash deploy/demo-preflight.sh` output

## Monitoring and Recovery

- Grafana system dashboard
- Prometheus targets page or preflight target output
- `bash deploy/demo-simulate-recovery.sh ...` output
- Post-recovery application page or Grafana health proof
