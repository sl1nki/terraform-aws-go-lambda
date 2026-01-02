# Go Lambda Module
#
# Reusable module for deploying Go Lambda functions with:
# - Source hash computation for change detection
# - Cross-compilation build process
# - CloudWatch log group
# - Lambda function configuration

locals {
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
  build_dir = "/tmp/${var.prefix}-${var.name}"
  zip_path  = "${local.build_dir}/lambda.zip"
}

# Build the Lambda zip
resource "terraform_data" "lambda_zip" {
  triggers_replace = [local.source_hash]

  provisioner "local-exec" {
    command = <<-EOF
      mkdir -p ${local.build_dir}
      cd "${local.go_src_path}"
      GOOS=linux GOARCH=${local.goarch} go build -tags lambda.norpc -o ${local.build_dir}/bootstrap ./${var.source_path}/
      cd ${local.build_dir} && zip -j lambda.zip bootstrap && rm bootstrap
    EOF
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.prefix}-${var.name}"
  retention_in_days = var.log_retention_days

  tags = {
    Name        = "${var.prefix} ${var.name} Lambda Logs"
    Environment = var.environment
  }
}

# Lambda Function
resource "aws_lambda_function" "this" {
  function_name = "${var.prefix}-${var.name}"
  role          = aws_iam_role.lambda.arn
  handler       = "bootstrap"
  runtime       = "provided.al2023"
  architectures = [var.architecture]

  filename         = local.zip_path
  source_code_hash = local.source_hash

  timeout     = var.timeout
  memory_size = var.memory_size

  dynamic "environment" {
    for_each = length(var.environment_variables) > 0 ? [1] : []
    content {
      variables = var.environment_variables
    }
  }

  depends_on = [
    aws_cloudwatch_log_group.lambda,
    aws_iam_role_policy_attachment.lambda_basic,
    terraform_data.lambda_zip,
  ]

  tags = {
    Name        = "${var.prefix} ${var.name}"
    Environment = var.environment
  }
}
