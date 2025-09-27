provider "aws" {
  region = "ap-south-1"
}

# ---------------------------
# Get default VPC & subnets
# ---------------------------
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# ---------------------------
# Security Group
# ---------------------------
resource "aws_security_group" "strapi_sg" {
  name        = "pooja-strapi-sg"
  description = "Allow HTTP for Strapi"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow HTTP"
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow ALB health checks"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ---------------------------
# ALB + Target Group + Listener
# ---------------------------
resource "aws_lb" "strapi_alb" {
  name               = "pooja-strapi-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.strapi_sg.id]
  subnets            = data.aws_subnets.default.ids
}

resource "aws_lb_target_group" "strapi_tg" {
  name     = "pooja-strapi-tg"
  port     = 1337
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    port                = "1337"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "strapi_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg.arn
  }
}

# ---------------------------
# ECS Cluster
# ---------------------------
resource "aws_ecs_cluster" "strapi_cluster" {
  name = "pooja-strapi-cluster"
}

# ---------------------------
# IAM Role for Task Execution
# ---------------------------
/*resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role-Strapi"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}*/
# ---------------------------
# ECS Task Definition
# ---------------------------
resource "aws_ecs_task_definition" "strapi_task" {
  family                   = "strapi-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn = "arn:aws:iam::145065858967:role/ecs-task-execution-role-Strapi"

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "123456789012.dkr.ecr.us-east-1.amazonaws.com/my-strapi-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          hostPort      = 1337
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "APP_KEYS", value = "key1,key2" },
        { name = "API_TOKEN_SALT", value = "mySalt" },
        { name = "ADMIN_JWT_SECRET", value = "myAdminSecret" },
        { name = "JWT_SECRET", value = "myJwtSecret" }
      ]
    }
  ])
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
    target_group_arn = aws_lb_target_group.strapi_tg.arn
    container_name   = "strapi"
    container_port   = 1337
  }

  depends_on = [aws_lb_listener.strapi_listener]
}
