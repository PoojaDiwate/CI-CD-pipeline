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
}*/

# Attach AmazonECSTaskExecutionRolePolicy to the existing role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_ecr" {
  role       = "ecs-task-execution-role-Strapi" # existing IAM role
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Minimal CloudWatch Logs permissions (attach)
resource "aws_iam_policy" "cwlogs_policy" {
  name        = "ecs-exec-cloudwatch-logs"
  description = "Allow ECS tasks to write CloudWatch Logs"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup",
          "logs:DescribeLogStreams"
        ],
        Resource = [
          "arn:aws:logs:${var.aws_region}:${var.aws_account_id}:log-group:${var.log_group_name}:*"
        ]
      }
    ]
  })
}

/*resource "aws_iam_role_policy_attachment" "exec_cwlogs_attach" {
  role       = "ecs-task-execution-role-Strapi"
  policy_arn = aws_iam_policy.cwlogs_policy.arn
}*/
