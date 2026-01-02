# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2026-01-02

### Changed

- Updated documentation to use Terraform Registry source format
- Added Terraform Registry badge to README

## [1.1.0] - 2026-01-02

### Added

- Comprehensive documentation (README, CONTRIBUTING, SECURITY.md)
- Five example configurations (basic, vpc, advanced-iam, multi-lambda, api-gateway)
- GitHub Actions CI/CD pipeline with format, validate, lint, and security checks
- Automated documentation generation with terraform-docs
- Pre-commit hooks via Lefthook
- Dependabot configuration for dependency updates
- Trivy security scanning configuration
- TFLint configuration with AWS ruleset

### Changed

- Repository is now public and ready for Terraform Registry publishing

### Fixed

- Corrected repository URLs in documentation

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

[Unreleased]: https://github.com/sl1nki/terraform-aws-go-lambda/compare/v1.1.1...HEAD
[1.1.1]: https://github.com/sl1nki/terraform-aws-go-lambda/compare/v1.1.0...v1.1.1
[1.1.0]: https://github.com/sl1nki/terraform-aws-go-lambda/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/sl1nki/terraform-aws-go-lambda/releases/tag/v1.0.0
