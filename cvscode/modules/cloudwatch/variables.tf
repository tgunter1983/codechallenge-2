variable "project_name" {
  type        = string
  description = "Project name prefix"
}

variable "cluster_name" {
  type        = string
  description = "ECS cluster name to monitor"
}

variable "alarm_email" {
  type        = string
  description = "Email address for alarm notifications"
}