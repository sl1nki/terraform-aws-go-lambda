# Example: Basic Go Lambda deployment
#
# This example demonstrates the simplest usage of the module.
# It creates a Lambda function with default settings and basic IAM permissions.

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

module "hello_lambda" {
  source = "../../"

  # Naming: Creates function named "example-hello"
  prefix      = "example"
  name        = "hello"
  environment = "development"

  # Go source location
  # Expects a main package at: {project_root}/{src_root}/{source_path}/
  source_path  = "cmd/hello"
  project_root = path.root
  src_root     = "."

  # Basic configuration (using defaults)
  memory_size = 128
  timeout     = 10

  # Environment variables passed to the Lambda function
  environment_variables = {
    GREETING = "Hello, World!"
  }
}

# Outputs
output "function_name" {
  description = "Lambda function name"
  value       = module.hello_lambda.function_name
}

output "function_arn" {
  description = "Lambda function ARN"
  value       = module.hello_lambda.function_arn
}

output "log_group_name" {
  description = "CloudWatch log group for Lambda logs"
  value       = module.hello_lambda.log_group_name
}
