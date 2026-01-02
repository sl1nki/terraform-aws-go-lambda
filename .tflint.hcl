plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "aws" {
  enabled = true
  version = "0.35.0"
  source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Naming conventions
rule "terraform_naming_convention" {
  enabled = true
}

# Require descriptions on variables and outputs
rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_documented_outputs" {
  enabled = true
}

# Standard module structure
rule "terraform_standard_module_structure" {
  enabled = true
}

# Warn on deprecated syntax
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# Require type declarations
rule "terraform_typed_variables" {
  enabled = true
}
