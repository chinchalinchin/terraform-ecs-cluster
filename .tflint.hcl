### Use below Plugin config to configure TFlint ###

## AWS Plugin ###
plugin "aws" {
    enabled = true
    version = "0.13.4"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

### Azure Plugin ###

# plugin "azurerm" {
#     enabled = true
#     version = "0.16.0"
#     source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
# }