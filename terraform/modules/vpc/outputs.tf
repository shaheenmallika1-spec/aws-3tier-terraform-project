output "vpc_id" {
  description = "ID of the custom VPC"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = [for key in ["public_a", "public_b"] : aws_subnet.this[key].id]
}

output "app_subnet_ids" {
  description = "IDs of the private application subnets"
  value       = [for key in ["app_a", "app_b"] : aws_subnet.this[key].id]
}

output "db_subnet_ids" {
  description = "IDs of the private database subnets"
  value       = [for key in ["db_a", "db_b"] : aws_subnet.this[key].id]
}