resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "PoojaStrapiHighCPU"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = var.service_name
  }
  alarm_description = "Alarm when Strapi service CPU > 80%"
}

resource "aws_cloudwatch_metric_alarm" "task_count_low" {
  alarm_name          = "PoojaStrapiTaskCountLow"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "RunningTaskCount"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster.name
    ServiceName = var.service_name
  }
  alarm_description = "Alert if no tasks running"
}
