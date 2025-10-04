resource "aws_cloudwatch_dashboard" "strapi" {
  dashboard_name = "Pooja_Strapi-ECS-Dashboard"
  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0, y = 0, width = 12, height = 6,
        properties = {
          view = "timeSeries",
          stacked = false,
          region = var.aws_region,
          title = "Service CPU Utilization",
          metrics = [
            ["AWS/ECS","CPUUtilization","ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", var.service_name]
          ],
          period = 60,
          stat = "Average"
        }
      },
      {
        type = "metric",
        x = 12, y = 0, width = 12, height = 6,
        properties = {
          view = "timeSeries",
          region = var.aws_region,
          title = "Service Memory Utilization",
          metrics = [
            ["AWS/ECS","MemoryUtilization","ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", var.service_name]
          ],
          period = 60,
          stat = "Average"
        }
      },
      {
        type = "metric",
        x = 0, y = 6, width = 24, height = 6,
        properties = {
          view = "timeSeries",
          region = var.aws_region,
          title = "Running Task Count",
          metrics = [
            ["AWS/ECS","RunningTaskCount","ClusterName", aws_ecs_cluster.strapi_cluster.name, "ServiceName", var.service_name]
          ],
          period = 60,
          stat = "Average"
        }
      }
    ]
  })
}
