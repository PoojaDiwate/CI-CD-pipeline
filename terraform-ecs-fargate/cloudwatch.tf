resource "aws_cloudwatch_log_group" "strapi" {
  name              = var.log_group_name
  retention_in_days = 1
  tags = {
    Project = "strapi"
  }
}
