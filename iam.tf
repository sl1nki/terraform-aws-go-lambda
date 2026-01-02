resource "aws_iam_role" "lambda" {
  name = "${var.prefix}-${var.name}-lambda"

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
  role       = aws_iam_role.lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Additional policy attachments
resource "aws_iam_role_policy_attachment" "additional" {
  for_each   = toset(var.additional_policy_arns)
  role       = aws_iam_role.lambda.name
  policy_arn = each.value
}

# Optional inline policy
resource "aws_iam_role_policy" "inline" {
  count  = var.inline_policy != null ? 1 : 0
  name   = "${var.prefix}-${var.name}-inline"
  role   = aws_iam_role.lambda.id
  policy = var.inline_policy
}
