# API Gateway Example

This example demonstrates integrating a Lambda function with API Gateway HTTP API for building REST APIs.

## Features

- HTTP API (lower latency, lower cost than REST API)
- CORS configuration
- Access logging
- X-Ray tracing enabled
- Catch-all route

## Go Handler Example

Your Lambda function should handle API Gateway events:

```go
package main

import (
    "context"
    "encoding/json"
    "net/http"

    "github.com/aws/aws-lambda-go/events"
    "github.com/aws/aws-lambda-go/lambda"
)

func handler(ctx context.Context, req events.APIGatewayV2HTTPRequest) (events.APIGatewayV2HTTPResponse, error) {
    response := map[string]string{
        "message": "Hello from Lambda!",
        "path":    req.RawPath,
    }

    body, _ := json.Marshal(response)

    return events.APIGatewayV2HTTPResponse{
        StatusCode: http.StatusOK,
        Body:       string(body),
        Headers: map[string]string{
            "Content-Type": "application/json",
        },
    }, nil
}

func main() {
    lambda.Start(handler)
}
```

## Deployment

```bash
tofu init
tofu apply
```

## Testing

After deployment:

```bash
# Get the API endpoint from outputs
curl $(tofu output -raw api_endpoint)

# Or test specific paths
curl $(tofu output -raw api_endpoint)/users
curl -X POST $(tofu output -raw api_endpoint)/orders -d '{"item": "test"}'
```

## Architecture

```
Client -> API Gateway HTTP API -> Lambda -> (Your Application Logic)
              |
              v
         CloudWatch Logs (Access Logs)
```

## Customizing Routes

For specific routes instead of catch-all:

```hcl
resource "aws_apigatewayv2_route" "get_users" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "GET /users"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}

resource "aws_apigatewayv2_route" "post_orders" {
  api_id    = aws_apigatewayv2_api.main.id
  route_key = "POST /orders"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
```
