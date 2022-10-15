### Provide TFVars to execute this example use-case ###

# module "canary_external" {
#   # Reference the canary repository directly
#   # source                = "git::https://github.boozallencsn.com/FRB-SRE/canary-external.git"
#   # Reference the canary repository locally
#   source                     = "../../"
#   target_service             = var.target_service
#   region                     = var.region
#   target_urls                = var.target_urls
#   enable_active_tracing      = var.enable_active_tracing
#   canary_role_arn            = data.aws_iam_role.canary_role.arn
#   canary_vpc_config          = var.canary_vpc_config
#   vpc_access_policy          = var.vpc_access_policy
#   evaluation_periods         = var.evaluation_periods
#   period                     = var.period
#   threshold                  = var.threshold
#   email_endpoints            = var.email_endpoints
#   canary_timeout             = var.canary_timeout
#   canary_schedule_expression = var.canary_schedule_expression
# }