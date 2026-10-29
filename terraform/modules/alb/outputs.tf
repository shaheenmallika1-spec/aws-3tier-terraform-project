
output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN of the application target group"
  value       = aws_lb_target_group.app.arn
}

output "flask_target_group_arn" {
  description = "ARN of the Flask target group on port 5000"
  value       = aws_lb_target_group.flask.arn
}