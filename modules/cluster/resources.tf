resource "aws_kms_key" "cluster_key" {
    description                                         = "KMS key for encrypting ${var.cluster_config.name} secrets"
    deletion_window_in_days                             = 10
    enable_key_rotation                                 = true
    customer_master_key_spec                            = "SYMMETRIC_DEFAULT"
    key_usage                                           = "ENCRYPT_DECRYPT"
    is_enabled                                          = true
    tags                                                = local.kms_tags
}


resource "aws_cloudwatch_log_group" "cluster_log_group" {
    name                                                = "${var.cluster_config.name}-log-group"
    kms_key_id                                          = aws_kms_key.cluster_key.arn
    retention_in_days                                   = local.cw_log_retention
}

resource "aws_s3_bucket" "lb_access_log_bucket" {
    #checkov:skip=CKV_AWS_144: "Ensure that S3 bucket has cross-region replication enabled"
    #checkov:skip=CKV_AWS_18: "Ensure the S3 bucket has access logging enabled"

    bucket                                              = "${var.cluster_config.name}-lb-access-logs"
    tags                                                = local.s3_tags

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                kms_master_key_id                       = aws_kms_key.cluster_key.arn
                sse_algorithm                           = "aws:kms"
            }
        }
    }

    versioning {
        enabled                                         = true
    }
}


resource "aws_ecs_cluster" "cluster" {
  name                                                  = var.cluster_config.name

  configuration {
    execute_command_configuration {
        kms_key_id                                      = aws_kms_key.cluster_key.arn
        logging                                         = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled                  = true
        cloud_watch_log_group_name                      = aws_cloudwatch_log_group.cluster_log_group.name
      }
    }
  }
}


resource "aws_service_discovery_private_dns_namespace" "cluster_namespace" {
  name                                                  = var.cluster_config.namespace
  description                                           = "Private DNS namespace for ${var.cluster_config.name} services"
  vpc                                                   = var.vpc_config.id
}


resource "aws_security_group" "cluster_sg" {
    name                                                = "${var.cluster_config.name}-cluster-sg"
    description                                         = "${var.cluster_config.name} security group"
    vpc_id                                              = var.vpc_config.id
    tags                                                = local.ecs_tags
}


resource "aws_security_group" "private_lb_sg" {
    name                                                = "${var.cluster_config.name}-private-lb-sg"
    description                                         = "${var.cluster_config.name} private load balancer security group"
    vpc_id                                              = var.vpc_config.id
    tags                                                = local.ecs_tags
}


resource "aws_security_group" "public_lb_sg" {
    name                                                = "${var.cluster_config.name}-public-lb-sg"
    description                                         = "${var.cluster_config.name} public load balancer security group"
    vpc_id                                              = var.vpc_config.id
    tags                                                = local.ecs_tags
}


resource "aws_security_group_rule" "cluster_self_ingress" {
    description                                         = "Restrict ${var.cluster_config.name} cluster access to cluster security group"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    security_group_id                                   = aws_security_group.cluster_sg.id
    source_security_group_id                            = aws_security_group.cluster_sg.id
} 


resource "aws_security_group_rule" "cluster_private_lb_ingress" {
    description                                         = "Allow ${var.cluster_config.name} cluster access from private load balancer security group"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    security_group_id                                   = aws_security_group.cluster_sg.id
    source_security_group_id                            = aws_security_group.private_lb_sg.id
} 


resource "aws_security_group_rule" "cluster_public_lb_ingress" {
    description                                         = "Allow ${var.cluster_config.name} cluster access from public load balancer security group"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    security_group_id                                   = aws_security_group.cluster_sg.id
    source_security_group_id                            = aws_security_group.public_lb_sg.id
} 


resource "aws_security_group_rule" "public_lb_web_ingress" {
    description                                         = "Restrict ${var.cluster_config.name} public load balancer to HTTPS traffic"
    type                                                = "ingress"
    from_port                                           = 443
    to_port                                             = 443
    protocol                                            = "TCP"
    cidr_blocks                                         = [
                                                        "0.0.0.0/0"
                                                    ]
    security_group_id                                   = aws_security_group.public_lb_sg.id
} 


resource "aws_lb" "cluster_public_lb" {
    name                                                = "${var.cluster_config.name}-cluster-public-lb"
    internal                                            = false
    load_balancer_type                                  = "application"
    security_groups                                     = [
                                                            aws_security_group.public_lb_sg.id
                                                        ]
    subnets                                             = var.vpc_config.public_subnet_ids

    enable_deletion_protection = true
    tags                                                = local.alb_tags

    access_logs {
        bucket                                          = aws_s3_bucket.lb_access_log_bucket.bucket
        prefix                                          = "${var.cluster_config.name}-public-lb"
        enabled = true
    }
}


resource "aws_lb" "cluster_private_lb" {
    name                                                = "${var.cluster_config.name}-cluster-private-lb"
    internal                                            = false
    load_balancer_type                                  = "application"
    security_groups                                     = [
                                                            aws_security_group.private_lb_sg.id
                                                        ]
    subnets                                             = var.vpc_config.private_subnet_ids

    enable_deletion_protection = true
    tags                                                = local.alb_tags

    access_logs {
        bucket                                          = aws_s3_bucket.lb_access_log_bucket.bucket
        prefix                                          = "${var.cluster_config.name}-private-lb"
        enabled = true
    }
}