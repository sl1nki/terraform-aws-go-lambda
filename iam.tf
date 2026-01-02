# IAM resources are only created when iam_role_arn is not provided

resource "aws_iam_role" "lambda" {
  count = var.iam_role_arn == null ? 1 : 0
  name  = "${var.prefix}-${var.name}-lambda"

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

  tags = {
    Name        = "${var.prefix} ${var.name} Lambda Role"
    Environment = var.environment
  }
}

# Basic execution role (CloudWatch logs)
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  count      = var.iam_role_arn == null ? 1 : 0
  role       = aws_iam_role.lambda[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
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
  name   = "${var.prefix}-${var.name}-inline"
  role   = aws_iam_role.lambda[0].id
  policy = var.inline_policy
}
