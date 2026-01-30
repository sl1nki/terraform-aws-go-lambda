# terraform-aws-go-lambda

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Terraform Registry](https://img.shields.io/badge/Terraform%20Registry-sl1nki%2Fgo--lambda%2Faws-blue)](https://registry.terraform.io/modules/sl1nki/go-lambda/aws)

Reusable OpenTofu/Terraform module for deploying Go Lambda functions on AWS with production-ready security features.

## Features

- Cross-compilation for Linux (arm64 by default for Graviton price/performance)
- Source hash computation for automatic change detection
- CloudWatch log group with configurable retention and optional KMS encryption
- Optional IAM role creation with basic execution policy
- Support for additional IAM policies and inline policies
- Environment variables support with optional KMS encryption
- Flexible naming: prefix+name or full function_name

### Security Features

- **VPC Support**: Deploy Lambda in private subnets for network isolation
- **KMS Encryption**: Encrypt environment variables and CloudWatch logs at rest
- **Permission Boundaries**: Prevent privilege escalation with IAM permission boundaries
- **Reserved Concurrency**: Protect against DoS attacks and control costs
- **Dead Letter Queues**: Capture failed async invocations for debugging
- **X-Ray Tracing**: Enable distributed tracing for observability

## Usage

### Basic Usage

```hcl
module "lambda_orders" {
  source  = "sl1nki/go-lambda/aws"
  version = "~> 1.1"

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
}
```

### With Security Features

```hcl
module "lambda_secure" {
  source  = "sl1nki/go-lambda/aws"
  version = "~> 1.1"

  prefix       = "myproject"
  name         = "secure-api"
  source_path  = "api/secure"
  project_root = path.root
  environment  = "production"

  # VPC configuration for network isolation
  vpc_subnet_ids         = var.private_subnet_ids
  vpc_security_group_ids = [aws_security_group.lambda.id]

  # KMS encryption
  kms_key_arn           = aws_kms_key.lambda.arn
  log_group_kms_key_arn = aws_kms_key.logs.arn

  # Security controls
  permission_boundary_arn        = aws_iam_policy.boundary.arn
  reserved_concurrent_executions = 100
  dead_letter_queue_arn          = aws_sqs_queue.dlq.arn

  # Observability
  enable_xray_tracing = true
  log_retention_days  = 90

  environment_variables = {
    LOG_LEVEL = "info"
  }
}
```

### With External IAM Role

```hcl
module "my_lambda" {
  source  = "sl1nki/go-lambda/aws"
  version = "~> 1.1"

  function_name = "${var.env}-my-function"
  iam_role_arn  = aws_iam_role.lambda_exec.arn
  source_path   = "api/my-function"
  project_root  = path.module
  src_root      = "../backend"

  environment_variables = {
    LOG_LEVEL = "info"
  }
}
```

See the [examples](./examples/) directory for more complete examples.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0, < 6.31 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_root | Project root path (absolute) | `string` | n/a | yes |
| source\_path | Path to Go source relative to src\_root (e.g., 'api/orders') | `string` | n/a | yes |
| additional\_policy\_arns | Additional IAM policy ARNs to attach to the Lambda role | `list(string)` | `[]` | no |
| additional\_source\_patterns | Additional file patterns to include in source hash (relative to src\_root) | `list(string)` | `[]` | no |
| architecture | CPU architecture (arm64 or x86\_64) | `string` | `"arm64"` | no |
| dead\_letter\_queue\_arn | ARN of SQS queue or SNS topic for failed async invocations | `string` | `null` | no |
| enable\_xray\_tracing | Enable AWS X-Ray tracing for the Lambda function | `bool` | `false` | no |
| environment | Environment tag (e.g., 'production', 'staging'). Required when using prefix+name. | `string` | `null` | no |
| environment\_variables | Environment variables for the Lambda function | `map(string)` | `{}` | no |
| function\_name | Full function name. If provided, prefix and name are ignored. | `string` | `null` | no |
| iam\_role\_arn | IAM role ARN for the Lambda. If provided, no IAM role is created. | `string` | `null` | no |
| inline\_policy | Optional inline IAM policy JSON | `string` | `null` | no |
| kms\_key\_arn | KMS key ARN for encrypting environment variables at rest | `string` | `null` | no |
| log\_group\_kms\_key\_arn | KMS key ARN for encrypting CloudWatch log group | `string` | `null` | no |
| log\_retention\_days | CloudWatch log retention in days | `number` | `14` | no |
| memory\_size | Lambda memory in MB | `number` | `128` | no |
| name | Lambda function name suffix (e.g., 'orders'). Required if function\_name not provided. | `string` | `null` | no |
| permission\_boundary\_arn | IAM permission boundary ARN to attach to the Lambda execution role | `string` | `null` | no |
| prefix | Project prefix for resource naming (e.g., 'myproject'). Required if function\_name not provided. | `string` | `null` | no |
| reserved\_concurrent\_executions | Reserved concurrent executions for the Lambda function. Set to 0 to disable, -1 for unreserved. | `number` | `-1` | no |
| src\_root | Root directory containing Go source, relative to project\_root | `string` | `"."` | no |
| timeout | Lambda timeout in seconds | `number` | `10` | no |
| vpc\_security\_group\_ids | VPC security group IDs for Lambda network configuration. Required if vpc\_subnet\_ids is set. | `list(string)` | `[]` | no |
| vpc\_subnet\_ids | VPC subnet IDs for Lambda network configuration. Required if vpc\_security\_group\_ids is set. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| function\_arn | Lambda function ARN |
| function\_name | Lambda function name |
| function\_version | Latest published version of the Lambda function |
| iam\_role\_arn | IAM role ARN (null if external role was provided) |
| iam\_role\_id | IAM role ID (null if external role was provided) |
| iam\_role\_name | IAM role name (null if external role was provided) |
| invoke\_arn | Lambda invoke ARN for API Gateway integration |
| lambda\_arn | Lambda function ARN (alias for function\_arn) |
| lambda\_name | Lambda function name (alias for function\_name) |
| log\_group\_arn | CloudWatch log group ARN |
| log\_group\_name | CloudWatch log group name |
<!-- END_TF_DOCS -->

## Architecture

The module defaults to `arm64` (AWS Graviton) which provides better price/performance. Set `architecture = "x86_64"` if you need x86.

## Build Process

The module builds Go binaries locally using cross-compilation:

```bash
GOOS=linux GOARCH=arm64 go build -tags lambda.norpc -o bootstrap ./source_path/
```

The `-tags lambda.norpc` flag reduces binary size by excluding unused RPC functionality.

### Source Hash Computation

The module computes a hash from:
- All `.go` files in the source path
- `go.mod` and `go.sum` files
- Any patterns specified in `additional_source_patterns`

Changes to these files trigger a Lambda redeployment.

### Directory Structure

Your Go project should have a structure like:

```
project/
├── backend/           # src_root
│   ├── go.mod
│   ├── go.sum
│   └── api/
│       └── orders/    # source_path = "api/orders"
│           └── main.go
└── terraform/
    └── main.tf        # project_root = path.root
```

## Troubleshooting

### Build Fails

- Ensure Go >= 1.21 is installed and in PATH
- Verify `source_path` points to a directory with a valid `main` package
- Check that `go.mod` exists in `src_root`

### Lambda Invocation Errors

- Check CloudWatch logs at `/aws/lambda/{function_name}`
- Ensure the handler expects API Gateway or direct invocation format
- Verify IAM permissions are sufficient

### VPC Lambda Cannot Access Internet

- Lambda in VPC requires NAT Gateway for outbound internet access
- Or use VPC endpoints for AWS services

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development setup and guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.
