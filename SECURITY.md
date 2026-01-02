# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security issue, please report it responsibly.

### How to Report

1. **Do NOT create a public GitHub issue** for security vulnerabilities
2. Email security concerns to the repository maintainer
3. Include as much detail as possible:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

### What to Expect

- Acknowledgment within 48 hours
- Regular updates on progress
- Credit in release notes (unless you prefer anonymity)

### Scope

This security policy covers:

- The Terraform/OpenTofu module code
- Example configurations
- CI/CD workflows
- Documentation that could lead to insecure deployments

### Out of Scope

- Vulnerabilities in AWS services themselves
- Issues in dependencies (report to upstream projects)
- Security misconfigurations in user deployments

## Security Best Practices

When using this module, we recommend:

1. **Use VPC deployment** for network isolation when handling sensitive data
2. **Enable KMS encryption** for environment variables and CloudWatch logs
3. **Set permission boundaries** to limit IAM role capabilities
4. **Configure reserved concurrency** to prevent DoS attacks
5. **Enable X-Ray tracing** for security monitoring and debugging
6. **Review IAM policies** before deployment to ensure least privilege
7. **Pin module versions** to specific releases rather than branches

See the [examples](./examples/) directory for secure configuration patterns.
