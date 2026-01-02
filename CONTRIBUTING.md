# Contributing to terraform-aws-go-lambda

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## Development Setup

### Prerequisites

- [OpenTofu](https://opentofu.org/) >= 1.0 or [Terraform](https://terraform.io/) >= 1.0
- [Go](https://go.dev/) >= 1.21
- [terraform-docs](https://terraform-docs.io/) (optional, for documentation generation)
- AWS CLI configured with appropriate credentials (for testing)

### Local Development

1. Clone the repository:

   ```bash
   git clone https://github.com/OWNER/terraform-aws-go-lambda.git
   cd terraform-aws-go-lambda
   ```

2. Install pre-commit hooks (optional but recommended):

   ```bash
   lefthook install
   ```

3. Format and validate:

   ```bash
   tofu fmt -recursive
   tofu init
   tofu validate
   ```

## Code Style

### Terraform/OpenTofu

- Use `tofu fmt` to format all `.tf` files
- Follow [HashiCorp's Terraform Style Conventions](https://developer.hashicorp.com/terraform/language/style)
- Use descriptive variable and resource names
- Include descriptions for all variables and outputs
- Add validation blocks for variables with constraints

### Documentation

- Keep README.md up to date with any changes
- Update CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/) format
- Document all new variables and outputs

## Testing

### Manual Testing

1. Navigate to an example directory:

   ```bash
   cd examples/basic
   ```

2. Create a `terraform.tfvars` file with your configuration:

   ```hcl
   project_root = "/path/to/your/go/project"
   source_path  = "cmd/lambda"
   ```

3. Initialize and apply:

   ```bash
   tofu init
   tofu plan
   tofu apply
   ```

4. Verify the Lambda function works as expected

5. Clean up:

   ```bash
   tofu destroy
   ```

## Pull Request Process

1. Fork the repository and create a feature branch from `main`
2. Make your changes following the code style guidelines
3. Update documentation as needed
4. Run `tofu fmt -check -recursive` and `tofu validate`
5. Submit a pull request with a clear description of the changes

### PR Requirements

- All CI checks must pass
- Code must be formatted with `tofu fmt`
- Module must validate with `tofu validate`
- CHANGELOG.md must be updated for user-facing changes
- New features should include example usage

## Reporting Issues

When reporting issues, please include:

- Terraform/OpenTofu version (`tofu version`)
- AWS provider version
- Go version
- Minimal reproduction steps
- Expected vs actual behavior
- Any relevant error messages

## Questions?

If you have questions about contributing, feel free to open an issue for discussion.
