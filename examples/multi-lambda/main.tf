# Example: Multiple Lambda Functions
#
# This example demonstrates deploying multiple Lambda functions
# using for_each with shared configuration.

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

locals {
  environment = "development"
  prefix      = "example"

  # Define multiple Lambda functions
  lambdas = {
    users = {
      source_path = "cmd/users"
      memory_size = 256
      timeout     = 30
      env_vars = {
        LOG_LEVEL = "info"
      }
    }
    orders = {
      source_path = "cmd/orders"
      memory_size = 512
      timeout     = 60
      env_vars = {
        LOG_LEVEL = "debug"
      }
    }
    notifications = {
      source_path = "cmd/notifications"
      memory_size = 128
      timeout     = 10
      env_vars = {
        LOG_LEVEL = "info"
      }
    }
  }
}

# Deploy multiple Lambda functions
module "lambdas" {
  source   = "../../"
  for_each = local.lambdas

  prefix      = local.prefix
  name        = each.key
  environment = local.environment

  source_path  = each.value.source_path
  project_root = path.root
  src_root     = "."

  memory_size = each.value.memory_size
  timeout     = each.value.timeout

  environment_variables = each.value.env_vars

  # Apply consistent settings across all functions
  log_retention_days = 30
}

# Outputs
output "function_names" {
  description = "Map of Lambda function names"
  value       = { for k, v in module.lambdas : k => v.function_name }
}

output "function_arns" {
  description = "Map of Lambda function ARNs"
  value       = { for k, v in module.lambdas : k => v.function_arn }
}

output "invoke_arns" {
  description = "Map of Lambda invoke ARNs for API Gateway"
  value       = { for k, v in module.lambdas : k => v.invoke_arn }
}
