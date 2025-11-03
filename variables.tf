# variables.tf (root)

variable "project_name" {
  type        = string
  description = "Project name for ECS and CloudWatch resources"
  default     = "hello" # optional default
}

variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}