# Examples

This directory contains examples demonstrating various use cases for the Go Lambda module.

## Available Examples

| Example | Description |
|---------|-------------|
| [basic](./basic/) | Simple Lambda deployment with default settings |
| [vpc](./vpc/) | Lambda deployed in VPC for network isolation |
| [advanced-iam](./advanced-iam/) | Custom IAM policies and permission boundaries |
| [multi-lambda](./multi-lambda/) | Deploy multiple functions using for_each |
| [api-gateway](./api-gateway/) | Lambda integrated with API Gateway HTTP API |

## Running Examples

Each example is a complete, standalone configuration. To run an example:

1. Navigate to the example directory:

   ```bash
   cd examples/basic
   ```

2. Create the Go source code (see example's README for code)

3. Initialize and apply:

   ```bash
   tofu init
   tofu apply
   ```

4. Clean up when done:

   ```bash
   tofu destroy
   ```

## Prerequisites

All examples require:

- OpenTofu >= 1.0 or Terraform >= 1.0
- Go >= 1.21
- AWS credentials configured
- `zip` utility

## Example Go Lambda Structure

Most examples expect this structure:

```
example/
├── cmd/
│   └── handler/
│       └── main.go    # Lambda handler
├── go.mod
├── go.sum
└── main.tf            # Terraform configuration
```

## Common Patterns

### Minimal Lambda Handler

```go
package main

import (
    "context"
    "github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, event interface{}) (string, error) {
    return "Hello!", nil
}

func main() {
    lambda.Start(handler)
}
```

### With Environment Variables

```go
package main

import (
    "context"
    "os"
    "github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context) (string, error) {
    return os.Getenv("MY_VAR"), nil
}

func main() {
    lambda.Start(handler)
}
```
