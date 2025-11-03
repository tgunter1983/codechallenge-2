output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_logs.name
}

output "sns_topic_arn" {
  value = module.cloudwatch.sns_topic_arn
}

output "s3_bucket_name" {
  value = module.s3.bucket_name
}