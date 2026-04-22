variable "aws_region" {
  description = "AWS region for the final-project infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Base project name used in tags and resource names."
  type        = string
  default     = "moviebooking-final"
}

variable "instance_name" {
  description = "Name tag applied to the production EC2 instance."
  type        = string
  default     = "moviebooking-final-prod"
}

variable "instance_type" {
  description = "EC2 instance type for the production host."
  type        = string
  default     = "t3.large"
}

variable "ami_id" {
  description = "AMI ID for the production host. Keep this pinned to avoid replacing the live instance unexpectedly."
  type        = string
  default     = "ami-0ec10929233384c7f"
}

variable "key_pair_name" {
  description = "Existing EC2 key pair name used for SSH access."
  type        = string
}

variable "vpc_id" {
  description = "Target VPC ID for the production host."
  type        = string
}

variable "subnet_id" {
  description = "Public subnet ID where the production host will run."
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance."
  type        = string
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 30
}

variable "security_group_description" {
  description = "Security group description. Keep the current imported description unless you explicitly want Terraform to replace it."
  type        = string
  default     = "launch-wizard-7 created 2026-04-22T14:07:54.819Z"
}

variable "cpu_credits" {
  description = "Burst credit mode for T-family instances."
  type        = string
  default     = "unlimited"
}

variable "app_domain" {
  description = "Primary application domain."
  type        = string
  default     = "tungtungtungtungsahur.site"
}

variable "grafana_domain" {
  description = "Grafana subdomain."
  type        = string
  default     = "grafana.tungtungtungtungsahur.site"
}
