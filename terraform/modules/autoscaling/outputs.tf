
variable "aws_region" {
  description = "AWS region for the application"
  type        = string
}

variable "secret_arn" {
  description = "ARN of the database credentials secret"
  type        = string
}
