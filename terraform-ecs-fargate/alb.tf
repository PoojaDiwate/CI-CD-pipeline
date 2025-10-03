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

resource "aws_lb_target_group" "strapi_tg_new" {
  name        = "pooja-strapi-tg-2"
  port        = 1337
  protocol    = "HTTP"
  target_type = "ip"       # <-- must be "ip" for awsvpc / Fargate
  vpc_id      = data.aws_vpc.default.id

  health_check {
  path                = "/"
  #port                = "traffic-port"   Use the port mapped by TG/ECS
  protocol            = "HTTP"
  matcher             = "200-399"
  interval            = 30
  timeout             = 5
  healthy_threshold   = 2
  unhealthy_threshold = 5   # Give Strapi a bit more retries to start
}
}

resource "aws_lb_listener" "strapi_listener" {
  load_balancer_arn = aws_lb.strapi_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.strapi_tg_new.arn
  }
}