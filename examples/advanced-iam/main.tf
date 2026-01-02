# Example: Advanced IAM Configuration
#
# This example demonstrates using additional IAM policies,
# inline policies, and permission boundaries.

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

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# DynamoDB table for the Lambda to access
resource "aws_dynamodb_table" "orders" {
  name         = "example-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "order_id"

  attribute {
    name = "order_id"
    type = "S"
  }

  tags = {
    Environment = "development"
  }
}

# Permission boundary to restrict maximum permissions
resource "aws_iam_policy" "boundary" {
  name = "example-lambda-boundary"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:*",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = "*"
      },
      {
        Effect   = "Deny"
        Action   = ["iam:*", "organizations:*"]
        Resource = "*"
      }
    ]
  })
}

# Lambda with advanced IAM configuration
module "orders_lambda" {
  source = "../../"

  prefix      = "example"
  name        = "orders-api"
  environment = "development"

  source_path  = "cmd/orders"
  project_root = path.root
  src_root     = "."

  memory_size = 256
  timeout     = 30

  # Permission boundary - limits maximum possible permissions
  permission_boundary_arn = aws_iam_policy.boundary.arn

  # Inline policy for DynamoDB access
  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DynamoDBAccess"
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query"
        ]
        Resource = [
          aws_dynamodb_table.orders.arn,
          "${aws_dynamodb_table.orders.arn}/index/*"
        ]
      }
    ]
  })

  # Additional managed policies (optional)
  # additional_policy_arns = [
  #   "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  # ]

  environment_variables = {
    TABLE_NAME = aws_dynamodb_table.orders.name
    LOG_LEVEL  = "info"
  }
}

output "function_name" {
  value = module.orders_lambda.function_name
}

output "iam_role_arn" {
  value = module.orders_lambda.iam_role_arn
}

output "dynamodb_table" {
  value = aws_dynamodb_table.orders.name
}
