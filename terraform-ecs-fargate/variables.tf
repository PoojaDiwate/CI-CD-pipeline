variable "image_tag" {
  description = "Docker image tag to deploy"
  type        = string
}

variable "aws_account_id" {
  description = "AWS account ID"
  type        = string
}

variable "ecr_repo" {
  description = "ECR repository name"
  type        = string
}
