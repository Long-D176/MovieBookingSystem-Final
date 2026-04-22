output "instance_id" {
  description = "Production EC2 instance ID."
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "Elastic IP attached to the production host."
  value       = aws_eip.app.public_ip
}

output "public_dns" {
  description = "Public DNS name of the production instance."
  value       = aws_instance.app.public_dns
}

output "security_group_id" {
  description = "Security group attached to the production host."
  value       = aws_security_group.moviebooking_final.id
}
