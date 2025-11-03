output "task_definition_file" {
  description = "Path to the generated ECS task definition JSON file"
  value       = local_file.ecs_task_def_json.filename
}

output "task_definition_family" {
  description = "Task definition family name"
  value       = aws_ecs_task_definition.hello_task.family
}
output "cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.hello_cluster.name
}

output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.hello_service.name
}