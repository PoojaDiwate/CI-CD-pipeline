variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0522ab6e1ddcc7055" # Ubuntu 22.04 LTS (Mumbai region)
}

variable "instance_type" {
  default = "t3.micro"
}

variable "key_name" {
  description = "EC2 key pair name for SSH"
  default     = "strapi_key_pooja"
}

variable "aws_account_id" {
  description = "Your AWS account ID"
}

variable "ecr_repo" {
  description = "ECR repository name for Strapi image"
}

variable "image_tag" {
  description = "Image tag from GitHub Actions (commit SHA)"
}
