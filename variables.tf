variable "prefix" {
  description = "Project prefix for resource naming (e.g., 'myproject'). Required if function_name not provided."
  type        = string
  default     = null
}

variable "name" {
  description = "Lambda function name suffix (e.g., 'orders'). Required if function_name not provided."
  type        = string
  default     = null
}

variable "function_name" {
  description = "Full function name. If provided, prefix and name are ignored."
  type        = string
  default     = null
}

variable "iam_role_arn" {
  description = "IAM role ARN for the Lambda. If provided, no IAM role is created."
  type        = string
  default     = null
}

variable "source_path" {
  description = "Path to Go source relative to src_root (e.g., 'api/orders')"
  type        = string
}

variable "project_root" {
  description = "Project root path (absolute)"
  type        = string
}

variable "src_root" {
  description = "Root directory containing Go source, relative to project_root"
  type        = string
  default     = "."
}

variable "environment" {
  description = "Environment tag (e.g., 'production', 'staging'). Required when using prefix+name."
  type        = string
  default     = null
}

variable "memory_size" {
  description = "Lambda memory in MB"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 10
}

variable "architecture" {
  description = "CPU architecture (arm64 or x86_64)"
  type        = string
  default     = "arm64"
}

variable "additional_policy_arns" {
  description = "Additional IAM policy ARNs to attach to the Lambda role"
  type        = list(string)
  default     = []
}

variable "inline_policy" {
  description = "Optional inline IAM policy JSON"
  type        = string
  default     = null
}

variable "additional_source_patterns" {
  description = "Additional file patterns to include in source hash (relative to src_root)"
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 14
}
