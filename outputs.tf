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

output "iam_role_arn" {
  description = "IAM role ARN"
  value       = aws_iam_role.lambda.arn
}

output "iam_role_name" {
  description = "IAM role name"
  value       = aws_iam_role.lambda.name
}
