resource "aws_kms_key" "cluster_key" {
    description                                         = "KMS key for encrypting ${var.cluster_config.cluster_name} secrets"
    deletion_window_in_days                             = 10
    enable_key_rotation                                 = true
    customer_master_key_spec                            = "SYMMETRIC_DEFAULT"
    key_usage                                           = "ENCRYPT_DECRYPT"
    is_enabled                                          = true
    tags                                                = local.kms_tags
}


resource "aws_cloudwatch_log_group" "cluster_log_group" {
    name                                                = "${var.cluster_config.cluster_name}-log-group"
    kms_key_id                                          = aws_kms_key.cluster_key.arn
    retention_in_days                                   = local.cw_log_retention
}


resource "aws_ecs_cluster" "cluster" {
  name                                                  = var.cluster_config.cluster_name

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
  description                                           = "Private DNS namespace for ${var.cluster_config.cluster_name} services"
  vpc                                                   = var.vpc_config.vpc_id
}


resource "aws_security_group" "cluster_sg" {
    name                                                = "${var.cluster_name}-cluster-sg"
    description                                         = "${var.cluster_name} security group"
    vpc_id                                              = var.vpc_config.vpc_id
    tags                                                = local.ecs_tags
}


resource "aws_security_group" "private_lb_sg" {
    name                                                = "${var.cluster_name}-private-lb-sg"
    description                                         = "${var.cluster_name} private load balancer security group"
    vpc_id                                              = var.vpc_config.vpc_id
    tags                                                = local.ecs_tags
}


resource "aws_security_group" "public_lb_sg" {
    name                                                = "${var.cluster_name}-public-lb-sg"
    description                                         = "${var.cluster_name} public load balancer security group"
    vpc_id                                              = var.vpc_config.vpc_id
    tags                                                = local.ecs_tags
}


resource "aws_security_group_rule" "cluster_self_ingress" {
    description                                         = "Restrict ${var.cluster_name} cluster access to cluster security group"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    security_group_id                                   = aws_security_group.cluster_sg.id
    source_security_group_id                            = aws_security_group.cluster_sg.id
} 


resource "aws_security_group_rule" "cluster_private_lb_ingress" {
    description                                         = "Allow ${var.cluster_name} cluster access from private load balancer security group"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    security_group_id                                   = aws_security_group.cluster_sg.id
    source_security_group_id                            = aws_security_group.private_lb_sg.id
} 


resource "aws_security_group_rule" "cluster_public_lb_ingress" {
    description                                         = "Allow ${var.cluster_name} cluster access from public load balancer security group"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    security_group_id                                   = aws_security_group.cluster_sg.id
    source_security_group_id                            = aws_security_group.public_lb_sg.id
} 


resource "aws_security_group_rule" "public_lb_web_ingress" {
    description                                         = "Restrict ${var.cluster_name} public load balancer to HTTPS traffic"
    type                                                = "ingress"
    from_port                                           = 443
    to_port                                             = 443
    protocol                                            = "TCP"
    security_group_id                                   = aws_security_group.public_lb_sg.id
} 