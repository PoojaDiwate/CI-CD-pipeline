resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = "arn:aws:iam::145065858967:role/ecs-task-execution-role-Strapi" #existing IAM role arn

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "145065858967.dkr.ecr.ap-south-1.amazonaws.com/strapi-app-pooja:cbd533c"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
      environment = [
        { name = "APP_KEYS", value = "key1,key2" },
        { name = "API_TOKEN_SALT", value = "mySalt" },
        { name = "ADMIN_JWT_SECRET", value = "myAdminSecret" },
        { name = "JWT_SECRET", value = "myJwtSecret" }
      ]
    }
  ])
}