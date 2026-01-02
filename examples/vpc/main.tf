# Example: Lambda in VPC
#
# This example demonstrates deploying a Lambda function inside a VPC
# for network isolation and access to private resources.

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0, < 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# VPC Configuration
data "aws_vpc" "main" {
  default = true
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# Security group for Lambda
resource "aws_security_group" "lambda" {
  name_prefix = "example-lambda-"
  description = "Security group for Lambda function"
  vpc_id      = data.aws_vpc.main.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-lambda-sg"
  }
}

# Lambda function in VPC
module "vpc_lambda" {
  source = "../../"

  prefix      = "example"
  name        = "vpc-function"
  environment = "development"

  source_path  = "cmd/vpc-handler"
  project_root = path.root
  src_root     = "."

  memory_size = 256
  timeout     = 30

  # VPC configuration - enables network isolation
  vpc_subnet_ids         = data.aws_subnets.private.ids
  vpc_security_group_ids = [aws_security_group.lambda.id]

  # Enable X-Ray for tracing in VPC
  enable_xray_tracing = true

  environment_variables = {
    LOG_LEVEL = "debug"
  }
}

output "function_name" {
  value = module.vpc_lambda.function_name
}

output "security_group_id" {
  value = aws_security_group.lambda.id
}
