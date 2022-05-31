# AWS region
# region = "us-east-1"
# # name of canary / service
# target_service = "cw-test"

# List of target URLs to test. Each will be tested (even if only one of them fails)
# target_urls = [
#   "http://httpstat.us/200",
#   "http://mysitethatdoesntexist.com",
#   "http://httpstat.us/404"
# ]

# # Whether to enable Xray active tracing (default false)
# enable_active_tracing = false

# # Specify existing role ARN or comment out to generate a new role (default "")
# canary_role_arn = "arn:aws:iam::677543473621:role/lambda_canary_role"

# # IF creating Role (rather than using an existing one), set to true to create role with permissions to access VPC (default false)
# vpc_access_policy = false
# # Set to non-empty to network from a specific subnet  (default {})
# canary_vpc_config = {
#   subnet_ids         = ["subnet-b7416b8a"],
#   security_group_ids = ["sg-0bc75670"]
# }

# # AWS Cloudwatch alarm settings (see https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html#alarm-evaluation)
# # (default 2)
# evaluation_periods = 2
# # (default 120)
# period             = 120
# # (default 1)
# threshold          = 1

# # AWS Synthetics canary run schedule and timeout
# # (default 60)
# canary_timeout = 60
# # (default "rate(1 minute)")
# canary_schedule_expression = "rate(1 minute)"

# Which emails to notify when AWS Cloudwatch Alarm gets triggered
email_endpoints = ["burnell_erik@bah.com", "husain_zoha@bah.com"]
