resource "aws_sns_topic" "alarm_topic" {
  name = "${var.project_name}-alarm-topic"
 
  tags = {
    Name        = "hello-world-bucket"
    Environment = "demo"
  }
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alarm_topic.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.project_name}-cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Alarm when ECS CPU exceeds 80%"
  alarm_actions       = [aws_sns_topic.alarm_topic.arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}