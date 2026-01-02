# terraform-aws-go-lambda

Reusable OpenTofu/Terraform module for deploying Go Lambda functions on AWS.

## Features

- Cross-compilation for Linux (arm64 by default)
- Source hash computation for automatic change detection
- CloudWatch log group with configurable retention
- IAM role with basic execution policy
- Support for additional IAM policies and inline policies
- Environment variables support

## Requirements

- OpenTofu >= 1.0 or Terraform >= 1.0
- Go toolchain (for local builds)
- `zip` utility
- AWS provider >= 5.0

## Usage

```hcl
module "lambda_orders" {
  source = "git::ssh://git@github.com/sl1nki/terraform-aws-go-lambda.git?ref=v1.0.0"

  prefix       = "myproject"
  name         = "orders"
  source_path  = "api/orders"
  project_root = path.root
  src_root     = "backend"
  environment  = "production"

  memory_size = 256
  timeout     = 30

  environment_variables = {
    LOG_LEVEL = "info"
  }

  inline_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["dynamodb:GetItem", "dynamodb:PutItem"]
        Resource = "arn:aws:dynamodb:*:*:table/orders"
      }
    ]
  })
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix | Project prefix for resource naming | `string` | - | yes |
| name | Lambda function name suffix | `string` | - | yes |
| source_path | Path to Go source relative to src_root | `string` | - | yes |
| project_root | Project root path (absolute) | `string` | - | yes |
| src_root | Root directory containing Go source | `string` | `"."` | no |
| environment | Environment tag | `string` | - | yes |
| memory_size | Lambda memory in MB | `number` | `128` | no |
| timeout | Lambda timeout in seconds | `number` | `10` | no |
| architecture | CPU architecture (arm64 or x86_64) | `string` | `"arm64"` | no |
| additional_policy_arns | Additional IAM policy ARNs to attach | `list(string)` | `[]` | no |
| inline_policy | Optional inline IAM policy JSON | `string` | `null` | no |
| additional_source_patterns | Additional file patterns for source hash | `list(string)` | `[]` | no |
| environment_variables | Environment variables for Lambda | `map(string)` | `{}` | no |
| log_retention_days | CloudWatch log retention in days | `number` | `14` | no |

## Outputs

| Name | Description |
|------|-------------|
| function_name | Lambda function name |
| function_arn | Lambda function ARN |
| invoke_arn | Lambda invoke ARN for API Gateway |
| iam_role_arn | IAM role ARN |
| iam_role_name | IAM role name |

## Architecture

The module defaults to `arm64` (AWS Graviton) which provides better price/performance. Set `architecture = "x86_64"` if you need x86.

## Build Process

The module builds Go binaries locally using cross-compilation:

```bash
GOOS=linux GOARCH=arm64 go build -tags lambda.norpc -o bootstrap ./source_path/
```

The `-tags lambda.norpc` flag reduces binary size by excluding unused RPC functionality.
