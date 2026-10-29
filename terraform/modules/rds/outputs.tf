output "db_endpoint" {
  description = "RDS endpoint for the application"
  value       = aws_db_instance.this.address
}

output "db_port" {
  description = "RDS database port"
  value       = aws_db_instance.this.port
}