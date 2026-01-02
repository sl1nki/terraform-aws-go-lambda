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

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "Memory size must be between 128 and 10240 MB."
  }
}

variable "timeout" {
  description = "Lambda timeout in seconds"
  type        = number
  default     = 10

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "Timeout must be between 1 and 900 seconds."
  }
}

variable "architecture" {
  description = "CPU architecture (arm64 or x86_64)"
  type        = string
  default     = "arm64"

  validation {
    condition     = contains(["arm64", "x86_64"], var.architecture)
    error_message = "Architecture must be either 'arm64' or 'x86_64'."
  }
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

  validation {
    condition     = var.inline_policy == null || can(jsondecode(var.inline_policy))
    error_message = "Inline policy must be valid JSON."
  }
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

  validation {
    condition     = contains([1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653, 0], var.log_retention_days)
    error_message = "Log retention must be a valid CloudWatch Logs retention value (0 for never expire, or 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1096, 1827, 2192, 2557, 2922, 3288, 3653 days)."
  }
}

# =============================================================================
# Security Configuration
# =============================================================================

variable "vpc_subnet_ids" {
  description = "VPC subnet IDs for Lambda network configuration. Required if vpc_security_group_ids is set."
  type        = list(string)
  default     = []
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs for Lambda network configuration. Required if vpc_subnet_ids is set."
  type        = list(string)
  default     = []
}

variable "kms_key_arn" {
  description = "KMS key ARN for encrypting environment variables at rest"
  type        = string
  default     = null
}

variable "log_group_kms_key_arn" {
  description = "KMS key ARN for encrypting CloudWatch log group"
  type        = string
  default     = null
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrent executions for the Lambda function. Set to 0 to disable, -1 for unreserved."
  type        = number
  default     = -1

  validation {
    condition     = var.reserved_concurrent_executions >= -1
    error_message = "Reserved concurrent executions must be -1 (unreserved) or >= 0."
  }
}

variable "dead_letter_queue_arn" {
  description = "ARN of SQS queue or SNS topic for failed async invocations"
  type        = string
  default     = null
}

variable "enable_xray_tracing" {
  description = "Enable AWS X-Ray tracing for the Lambda function"
  type        = bool
  default     = false
}

variable "permission_boundary_arn" {
  description = "IAM permission boundary ARN to attach to the Lambda execution role"
  type        = string
  default     = null
}
