# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-01-02

### Added

- Initial release of the Go Lambda module
- Cross-compilation build process for Go functions targeting AWS Lambda
- Source hash computation for automatic change detection
- CloudWatch log group with configurable retention
- IAM role with basic execution permissions
- Support for additional IAM policy attachments
- Support for inline IAM policies
- Environment variables configuration
- Configurable memory and timeout settings
- Support for both arm64 (Graviton) and x86_64 architectures

### Security

- VPC configuration support for network isolation
- KMS encryption for environment variables
- KMS encryption for CloudWatch log groups
- IAM permission boundaries support
- Reserved concurrent executions for DoS protection
- Dead letter queue configuration for failed async invocations
- X-Ray tracing support for observability
- Input validation for all constrained variables
- Secure build script with proper error handling and quoting

[Unreleased]: https://github.com/OWNER/terraform-aws-go-lambda/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/OWNER/terraform-aws-go-lambda/releases/tag/v1.0.0
