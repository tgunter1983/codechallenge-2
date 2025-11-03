variable "project_name" {
  type        = string
  description = "Project name prefix (used for ECS task definition)"
}

variable "cluster_name" {
  type        = string
  description = "ECS cluster name to verify"
}

variable "log_group_name" {
  type        = string
  description = "CloudWatch log group name to verify"
}
