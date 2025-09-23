variable "aws_region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-0522ab6e1ddcc7055" # Ubuntu 22.04 LTS (Mumbai region)
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "aws_account_id" {
  description = "Your AWS account ID"
}

variable "ecr_repo" {
  description = "ECR repository name for Strapi image"
}

variable "image_tag" {
  description = "Image tag from GitHub Actions"
}

variable "keypair" {
  description = "Name of the existing EC2 SSH key pair"
  type        = string
  default     = "strapi_key_pooja"  # the name of your already created key pair
}
