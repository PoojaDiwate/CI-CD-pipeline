output "alb_dns_name" {
  value = aws_lb.strapi_alb.dns_name
}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.ecs_app.name
}
