### Ignore TFSec rules - see example here ###
# #tfsec:ignore:aws-s3-enable-bucket-logging

# resource "aws_s3_bucket" "s3_bucket" {
#   bucket = var.bucket_name
#   acl    = "private"

#   server_side_encryption_configuration {
#     rule {
#       apply_server_side_encryption_by_default {
#         sse_algorithm = "AES256"
#       }
#     }
#   }
#   versioning {
#     enabled = true
#   }


###  Skip checkov rules - see example here ###
#   #checkov:skip=CKV_AWS_18:No sensitive data in this bucket (don't need to log)
#   #checkov:skip=CKV_AWS_144:No critical data in this bucket (don't need cross-region replication)
#   #checkov:skip=CKV_AWS_145:No sensitive data in this bucket (don't need encrypted buckets)
# }

# resource "aws_s3_bucket_public_access_block" "s3_bucket_access" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   block_public_acls       = true
#   block_public_policy     = true
#   restrict_public_buckets = true
#   ignore_public_acls      = true
# }

# resource "aws_s3_bucket_metric" "enable_metrics_s3_bucket" {
#   bucket = aws_s3_bucket.s3_bucket.bucket
#   name   = "${var.bucket_name}-metrics"
# }