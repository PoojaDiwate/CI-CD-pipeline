provider "aws" {
  region = var.aws_region
}

# Use existing VPC
data "aws_vpc" "existing" {
  id = "vpc-098cc44dc4ec933d7"  # replace with your VPC ID
}

# Use existing subnets
data "aws_subnets" "existing" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

# Use existing Internet Gateway
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

data "aws_route_table" "existing" {
  subnet_id = data.aws_subnets.existing.ids[0]
}

# Security Group
resource "aws_security_group" "strapi_sg" {
  vpc_id = data.aws_vpc.existing.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "strapi_server_pooja" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnets.existing.ids[0]
  vpc_security_group_ids = [aws_security_group.strapi_sg.id]
  key_name               = var.keypair  # your key pair variable

   user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io awscli
              systemctl start docker
              systemctl enable docker
              usermod -aG docker ubuntu

              # Login to ECR
              aws ecr get-login-password --region ${var.aws_region} | \
              docker login --username AWS --password-stdin ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com

              # Run Strapi container
              docker run -d -p 1337:1337 ${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repo}:${var.image_tag}
              EOF

  tags = {
    Name = "Strapi-Server-Pooja"
  }
}