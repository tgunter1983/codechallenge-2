# --- ECS Verification ---
data "aws_ecs_cluster" "verify" {
  cluster_name = var.cluster_name
}

data "aws_ecs_task_definition" "verify" {
  task_definition = "${var.project_name}-task"
}

# --- CloudWatch Log Group ---
data "aws_cloudwatch_log_group" "verify" {
  name = var.log_group_name
}

# --- Local Checks ---
locals {
  cluster_ok   = data.aws_ecs_cluster.verify.status == "ACTIVE"
  # Just ensure revision is a valid number (>0)
  task_def_ok  = try(data.aws_ecs_task_definition.verify.revision, 0) > 0
  log_group_ok = data.aws_cloudwatch_log_group.verify.name != ""
}

# --- Fail if ECS Cluster Inactive ---
resource "null_resource" "verify_cluster" {
  count = local.cluster_ok ? 0 : 1
  provisioner "local-exec" {
    command = "echo '❌ ECS cluster is not ACTIVE' && exit 1"
  }
}

# --- Fail if ECS Task Definition Missing ---
resource "null_resource" "verify_taskdef" {
  count = local.task_def_ok ? 0 : 1
  provisioner "local-exec" {
    command = "echo '❌ ECS task definition not found or invalid' && exit 1"
  }
}

# --- Fail if CloudWatch Log Group Missing ---
resource "null_resource" "verify_loggroup" {
  count = local.log_group_ok ? 0 : 1
  provisioner "local-exec" {
    command = "echo '❌ CloudWatch Log Group not found' && exit 1"
  }
}

# --- Outputs ---
output "ecs_cluster_verified" {
  value       = local.cluster_ok
  description = "True if ECS cluster is active"
}

output "ecs_taskdef_verified" {
  value       = local.task_def_ok
  description = "True if ECS task definition exists"
}

output "loggroup_verified" {
  value       = local.log_group_ok
  description = "True if CloudWatch Log Group exists"
}
