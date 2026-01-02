# Basic Example

This example demonstrates the simplest usage of the Go Lambda module.

## Usage

1. Create a Go Lambda function at `cmd/hello/main.go`:

```go
package main

import (
    "context"
    "os"
    "github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context) (string, error) {
    greeting := os.Getenv("GREETING")
    return greeting, nil
}

func main() {
    lambda.Start(handler)
}
```

2. Initialize your Go module:

```bash
go mod init example
go mod tidy
```

3. Deploy:

```bash
tofu init
tofu apply
```

## What Gets Created

- Lambda function: `example-hello`
- IAM role: `example-hello-lambda`
- CloudWatch log group: `/aws/lambda/example-hello`
