output "instance_id" {
  description = "ID of the application EC2 instance"
  value       = aws_instance.app.id
}

output "private_ip" {
  description = "Private IP of the application EC2 instance"
  value       = aws_instance.app.private_ip
}

output "instance_profile_name" {
  description = "IAM instance profile used by application EC2 instances"
  value       = aws_iam_instance_profile.ssm.name
}


output "ssm_role_name" {
  description = "IAM role used by application EC2 instances"
  value       = aws_iam_role.ssm.name
}
