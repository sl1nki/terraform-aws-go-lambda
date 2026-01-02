See [CHANGELOG.md](https://github.com/OWNER/terraform-aws-go-lambda/blob/main/CHANGELOG.md) for detailed release notes.

## Installation

```hcl
module "go_lambda" {
  source = "git::https://github.com/OWNER/terraform-aws-go-lambda.git?ref=VERSION"

  prefix       = "myapp"
  name         = "handler"
  source_path  = "cmd/handler"
  project_root = path.root
  environment  = "production"
}
```
