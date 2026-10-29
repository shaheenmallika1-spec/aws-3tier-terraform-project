variable "project_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_username" {
  description = "MySQL administrator username"
  type        = string
}

variable "db_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
}

variable "db_security_group_id" {
  description = "Security group ID for the database"
  type        = string
}