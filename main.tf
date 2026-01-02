# Go Lambda Module
#
# Reusable module for deploying Go Lambda functions with:
# - Source hash computation for change detection
# - Cross-compilation build process
# - CloudWatch log group
# - Lambda function configuration

locals {
  # Determine the function name - use function_name if provided, otherwise prefix-name
  lambda_function_name = var.function_name != null ? var.function_name : "${var.prefix}-${var.name}"

  # Map AWS architecture to Go GOARCH
  goarch = var.architecture == "arm64" ? "arm64" : "amd64"

  # Full path to Go source
  go_src_path = "${var.project_root}/${var.src_root}"

  # Base pattern for this lambda's source files
  base_pattern = "${var.source_path}/**/*.go"

  # Combine base + additional patterns + go.mod/go.sum
  all_patterns = concat(
    [local.base_pattern],
    var.additional_source_patterns,
    ["go.mod", "go.sum"]
  )

  # Collect all matching files
  source_files = toset(flatten([
    for pattern in local.all_patterns : fileset(local.go_src_path, pattern)
  ]))

  # Compute source hash from all matched files
  source_hash = sha256(join("", [
    for f in sort(local.source_files) : filesha256("${local.go_src_path}/${f}")
  ]))

  # Build paths - isolated per lambda to avoid parallel build collisions
  build_dir = "/tmp/${local.lambda_function_name}"
  zip_path  = "${local.build_dir}/lambda.zip"

  # IAM role ARN - use provided or created
  lambda_role_arn = var.iam_role_arn != null ? var.iam_role_arn : aws_iam_role.lambda[0].arn
}

# Build the Lambda zip
resource "terraform_data" "lambda_zip" {
  triggers_replace = [local.source_hash]

  provisioner "local-exec" {
    command = <<-EOF
      set -euo pipefail
      mkdir -p "${local.build_dir}"
      cd "${local.go_src_path}"
      GOOS=linux GOARCH="${local.goarch}" go build -tags lambda.norpc -o "${local.build_dir}/bootstrap" "./${var.source_path}/"
      chmod +x "${local.build_dir}/bootstrap"
      cd "${local.build_dir}" && zip -j lambda.zip bootstrap && rm bootstrap
    EOF
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = var.log_retention_days
  kms_key_id        = var.log_group_kms_key_arn

  tags = var.prefix != null ? {
    Name        = "${var.prefix} ${var.name} Lambda Logs"
    Environment = var.environment
  } : {}
}

# Lambda Function
resource "aws_lambda_function" "this" {
  function_name = local.lambda_function_name
  role          = local.lambda_role_arn
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  architectures = [var.architecture]

  filename         = local.zip_path
  source_code_hash = local.source_hash

  timeout     = var.timeout
  memory_size = var.memory_size

  # Security: KMS encryption for environment variables
  kms_key_arn = var.kms_key_arn

  # Security: Reserved concurrent executions (DoS protection)
  reserved_concurrent_executions = var.reserved_concurrent_executions >= 0 ? var.reserved_concurrent_executions : null

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  # Security: VPC configuration for network isolation
  dynamic "vpc_config" {
    for_each = length(var.vpc_subnet_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.vpc_subnet_ids
      security_group_ids = var.vpc_security_group_ids
    }
  }

  # Security: Dead letter queue for failed async invocations
  dynamic "dead_letter_config" {
    for_each = var.dead_letter_queue_arn != null ? [1] : []
    content {
      target_arn = var.dead_letter_queue_arn
    }
  }

  # Observability: X-Ray tracing
  tracing_config {
    mode = var.enable_xray_tracing ? "Active" : "PassThrough"
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    terraform_data.lambda_zip,
  ]

  tags = var.prefix != null ? {
    Name        = "${var.prefix} ${var.name}"
    Environment = var.environment
  } : {}
}
