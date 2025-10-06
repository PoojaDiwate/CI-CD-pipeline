variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "aws_region" {
  type = string
  default = "ap-south-1"
}

variable "ecr_repo" {
  description = "ECR repository name"
  type        = string
}
