variable "region" {
  default = "ap-south-1"
}

variable "vpc_id" {
  description = "VPC where ALB and ECS are created"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of public subnets for ECS tasks and ALB"
}

variable "ecs_task_execution_role_arn" {
  description = "Existing ECS Task Execution Role ARN"
}

variable "image_url" {
  description = "ECR image URL for Strapi app"
}