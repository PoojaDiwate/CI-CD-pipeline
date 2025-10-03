variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "aws_region" { 
  type = string }

variable "ecr_repo" {
  description = "ECR repository name"
  type        = string
}

variable "log_group_name" { 
  type = string 
  default = "/ecs/strapi" 
}

variable "service_name" { 
  type = string, 
  default = "strapi-service" 
}

variable "aws_region" { 
  type = string }
