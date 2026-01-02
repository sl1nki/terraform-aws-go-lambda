# IAM resources are only created when iam_role_arn is not provided

locals {
  # These names use coalesce to satisfy TFLint static analysis.
  # When count = 0, the interpolation result doesn't matter.
  iam_role_name   = "${coalesce(var.prefix, "x")}-${coalesce(var.name, "x")}-lambda"
  iam_inline_name = "${coalesce(var.prefix, "x")}-${coalesce(var.name, "x")}-inline"
}

resource "aws_iam_role" "lambda" {
  count = var.iam_role_arn == null ? 1 : 0
  name  = local.iam_role_name

  # Security: Permission boundary for privilege escalation prevention
  permissions_boundary = var.permission_boundary_arn

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = var.prefix != null ? {
    Name        = "${var.prefix} ${var.name} Lambda Role"
    Environment = var.environment
  } : {}
}

# Basic execution role (CloudWatch logs)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  count      = var.iam_role_arn == null ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# VPC execution role (required when Lambda is deployed in VPC)
resource "aws_iam_role_policy_attachment" "lambda_vpc" {
  count      = var.iam_role_arn == null && length(var.vpc_subnet_ids) > 0 ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# X-Ray tracing role (required when X-Ray tracing is enabled)
resource "aws_iam_role_policy_attachment" "lambda_xray" {
  count      = var.iam_role_arn == null && var.enable_xray_tracing ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

# Additional policy attachments
resource "aws_iam_role_policy_attachment" "additional" {
  for_each   = var.iam_role_arn == null ? toset(var.additional_policy_arns) : toset([])
  role       = aws_iam_role.lambda[0].name
  policy_arn = each.value
}

# Optional inline policy
resource "aws_iam_role_policy" "inline" {
  count  = var.iam_role_arn == null && var.inline_policy != null ? 1 : 0
  name   = local.iam_inline_name
  role   = aws_iam_role.lambda[0].id
  policy = var.inline_policy
}
