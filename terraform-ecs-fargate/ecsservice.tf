# ---------------------------
# ECS Cluster
# ---------------------------
resource "aws_ecs_cluster" "strapi_cluster" {
  name = "pooja-strapi-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# ---------------------------
# ECS Service
# ---------------------------
resource "aws_ecs_service" "strapi_service" {
  name            = "pooja-strapi-service"
  cluster         = aws_ecs_cluster.strapi_cluster.id
  task_definition = aws_ecs_task_definition.strapi_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.default.ids
    security_groups = [aws_security_group.strapi_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.strapi_tg_new.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.strapi_listener]
}
