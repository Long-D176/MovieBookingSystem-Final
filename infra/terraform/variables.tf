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
