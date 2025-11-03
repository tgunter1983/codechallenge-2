output "sns_topic_arn" {
  description = "ARN of SNS topic for CloudWatch alarms"
  value       = aws_sns_topic.alarm_topic.arn
}

output "alarm_name" {
  description = "Name of ECS CPU utilization alarm"
  value       = aws_cloudwatch_metric_alarm.ecs_cpu_high.alarm_name
}