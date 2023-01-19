data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_vpc" "cluster_vpc" {
    id                                                  = var.vpc_config.vpc_id
}