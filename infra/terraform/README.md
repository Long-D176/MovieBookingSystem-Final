# Terraform Notes

This folder defines the Tier 2 production host for the final project:

- 1 Ubuntu 24.04 EC2 instance
- 1 security group exposing `22`, `80`, and `443`
- 1 Elastic IP

## Fresh Apply

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Fill in the real VPC, subnet, key pair, and operator SSH CIDR values
3. Export temporary AWS Learner Lab credentials in your shell
4. Run:

```bash
terraform init
terraform plan
terraform apply
```

## Import Existing Lab Resources

Because the current production instance was created manually first, you can import the live AWS resources into Terraform state instead of recreating them.

Example pattern:

```bash
terraform init
terraform import aws_security_group.moviebooking_final sg-xxxxxxxxxxxxxxxxx
terraform import aws_instance.app i-xxxxxxxxxxxxxxxxx
terraform import aws_eip.app eipalloc-xxxxxxxxxxxxxxxxx
```

After import:

1. run `terraform plan`
2. compare the drift with the live AWS console values
3. update variables if Terraform wants to recreate something unexpectedly
4. only apply when the plan is safe

## Important

- Do not commit `terraform.tfvars`
- Do not commit AWS credentials
- AWS Learner Lab credentials are temporary and may need to be refreshed
