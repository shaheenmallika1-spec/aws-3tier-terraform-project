variable "project_name" {
  description = "Project name used for resource tags"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "ID of the custom VPC"
  type        = string
}