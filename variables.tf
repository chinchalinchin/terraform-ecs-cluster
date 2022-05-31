### Root Module Variables ###

# variable "target_service" {
#   description = "Cannonical name of service this canary is monitoring"
#   type        = string
# }

# variable "region" {
#   description = "AWS Region for Canary Deployment"
#   type        = string
#   default     = "us-east-1"
# }

# variable "target_urls" {
#   description = "URLs of the target service to monitor"
#   type        = set(string)
# }

# variable "enable_active_tracing" {
#   description = "Determine whether to enable active tracing"
#   type        = bool
#   default     = false
# }

# variable "canary_role_arn" {
#   description = "Optional: ARN for the Canary IAM Role"
#   type        = string
#   default     = ""
# }

# variable "canary_vpc_config" {
#   description = "Map of subnet ids and security group ids"
#   type        = map(any)
#   # type        = object({
#   #   subnet_ids = optional(string)
#   #   security_group_ids = optional(string)
#   # })
#   default = {}
# }

# variable "vpc_access_policy" {
#   description = "Boolean value to determine whether VPC access policy is needed"
#   type        = bool
#   default     = false
# }

# variable "evaluation_periods" {
#   description = "The number of periods over which data is compared to the specified threshold"
#   type        = string
#   default     = 2
# }

# variable "period" {
#   description = "The period in seconds over which the specified statistic is applied"
#   type        = string
#   default     = 120
# }

# variable "threshold" {
#   description = "The value against which the specified statistic is compared"
#   type        = string
#   default     = 1
# }

# variable "email_endpoints" {
#   description = "The email address or list of email addresses that are sent alerts"
#   type        = set(string)
# }

# variable "canary_runtime_version" {
#   description = "AWS Synthetics canary runtime version"
#   type        = string
#   default     = "syn-nodejs-puppeteer-3.2"
# }

# variable "canary_timeout" {
#   type        = number
#   default     = 60
#   description = "AWS Synthetics canary run timeout"
# }

# variable "canary_schedule_expression" {
#   type        = string
#   default     = "rate(1 minute)"
#   description = "AWS Synthetics canary schedule expression"
# }