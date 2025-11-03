variable "project_name" {
  type        = string
  description = "Project name for ECS resources"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for ECS tasks"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for ECS tasks"
}
variable "log_group_name" {
  type        = string
  description = "Name of CloudWatch log group for ECS task"
}
variable "aws_region" {
  type        = string
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}