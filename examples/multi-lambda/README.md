# Multi-Lambda Example

This example demonstrates deploying multiple Lambda functions using `for_each` with shared configuration patterns.

## Pattern

Define Lambda configurations in a local map:

```hcl
locals {
  lambdas = {
    users = {
      source_path = "cmd/users"
      memory_size = 256
      timeout     = 30
    }
    orders = {
      source_path = "cmd/orders"
      memory_size = 512
      timeout     = 60
    }
  }
}
```

Then use `for_each`:

```hcl
module "lambdas" {
  source   = "../../"
  for_each = local.lambdas

  prefix = "myapp"
  name   = each.key
  # ... use each.value for configuration
}
```

## Benefits

- Consistent configuration across functions
- Easy to add/remove functions
- Single source of truth for shared settings
- Outputs as maps for easy reference

## Project Structure

```
project/
├── cmd/
│   ├── users/
│   │   └── main.go
│   ├── orders/
│   │   └── main.go
│   └── notifications/
│       └── main.go
├── go.mod
├── go.sum
└── terraform/
    └── main.tf
```

## Deployment

```bash
tofu init
tofu apply
```

## Referencing Outputs

```hcl
# Access a specific function's ARN
resource "aws_lambda_permission" "users_api" {
  function_name = module.lambdas["users"].function_name
  # ...
}
```
