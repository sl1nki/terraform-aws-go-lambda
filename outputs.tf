output "function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.this.function_name
}

output "function_arn" {
  description = "Lambda function ARN"
  value       = aws_lambda_function.this.arn
}

output "invoke_arn" {
  description = "Lambda invoke ARN for API Gateway integration"
  value       = aws_lambda_function.this.invoke_arn
}

output "function_version" {
  description = "Latest published version of the Lambda function"
  value       = aws_lambda_function.this.version
}

output "iam_role_arn" {
  description = "IAM role ARN (null if external role was provided)"
  value       = var.iam_role_arn == null ? aws_iam_role.lambda[0].arn : null
}

output "iam_role_name" {
  description = "IAM role name (null if external role was provided)"
  value       = var.iam_role_arn == null ? aws_iam_role.lambda[0].name : null
}

output "iam_role_id" {
  description = "IAM role ID (null if external role was provided)"
  value       = var.iam_role_arn == null ? aws_iam_role.lambda[0].id : null
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.lambda.name
}

output "log_group_arn" {
  description = "CloudWatch log group ARN"
  value       = aws_cloudwatch_log_group.lambda.arn
}

# Aliases for compatibility
output "lambda_arn" {
  description = "Lambda function ARN (alias for function_arn)"
  value       = aws_lambda_function.this.arn
}

output "lambda_name" {
  description = "Lambda function name (alias for function_name)"
  value       = aws_lambda_function.this.function_name
}
