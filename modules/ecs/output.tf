output "task_definition_file" {
  description = "Path to the generated ECS task definition JSON file"
  value       = local_file.ecs_task_def_json.filename
}

output "task_definition_family" {
  description = "Task definition family name"
  value       = aws_ecs_task_definition.hello_task.family
}