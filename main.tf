terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
}

# -- VPC & Subnets --
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default_vpc_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# -- Security Group --
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-hello-sg"
  description = "Allow HTTP traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
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
# Modules

# -- ECS Cluster Module --
module "ecs" {
  source             = "./modules/ecs"
  project_name       = "hello"
  subnet_ids         = data.aws_subnets.default_vpc_subnets.ids
  security_group_ids = [aws_security_group.ecs_sg.id]
  log_group_name     = aws_cloudwatch_log_group.ecs_logs.name
}

# -- S3 Bucket Module -- 
module "s3" {
  source      = "./modules/s3"
}

# -- CloudWatch Logs --
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project_name}"
  retention_in_days = 7
}

# -- CloudWatch Alarm Module --
module "cloudwatch" {
  source         = "./modules/cloudwatch"
  project_name   = var.project_name
  cluster_name   = module.ecs.cluster_name
  alarm_email    = "timwgutner@outlook.com"
}

# -- Test Module --
module "verify" {
  source          = "./modules/verify"
  project_name    = var.project_name
  cluster_name    = module.ecs.cluster_name
  log_group_name  = aws_cloudwatch_log_group.ecs_logs.name
}