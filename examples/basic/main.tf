# Example: Basic Go Lambda deployment

module "hello_lambda" {
  source = "../../"

  prefix       = "example"
  name         = "hello"
  source_path  = "cmd/hello"
  project_root = path.root
  src_root     = "."
  environment  = "development"

  memory_size = 128
  timeout     = 10

  environment_variables = {
    GREETING = "Hello, World!"
  }
}

output "function_name" {
  value = module.hello_lambda.function_name
}

output "function_arn" {
  value = module.hello_lambda.function_arn
}
