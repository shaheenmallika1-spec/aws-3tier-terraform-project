
variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "Existing VPC ID"
  type        = string
}

variable "app_subnet_ids" {
  description = "Private application subnet IDs"
  type        = list(string)
}

variable "app_security_group_id" {
  description = "Existing application security group ID"
  type        = string
}

variable "target_group_arn" {
  description = "Existing Flask target group ARN"
  type        = string
}

variable "instance_profile_name" {
  description = "Existing EC2 IAM instance profile"
  type        = string
}

variable "db_endpoint" {
  description = "Existing RDS endpoint"
  type        = string
}

variable "db_port" {
  description = "RDS port"
  type        = number
  default     = 3306
}

variable "db_name" {
  description = "Application database name"
  type        = string
  default     = "appdb"
}


variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "Minimum ASG capacity"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "Initial ASG capacity"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum ASG capacity"
  type        = number
  default     = 2
}
