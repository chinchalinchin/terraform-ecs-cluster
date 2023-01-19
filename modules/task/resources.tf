resource "aws_appautoscaling_target" "task_replica_targets" {
  service_namespace                                 = "ecs"
  scalable_dimension                                = "ecs:service:DesiredCount"
  resource_id                                       = "service/${var.cluster_config.name}/${var.service_config.name}"
  min_capacity                                      = local.autoscale_min
  max_capacity                                      = local.autoscale_max
}


resource "aws_appautoscaling_policy" "task_policy" {
    name                                              = "scale-down"
    policy_type                                       = "TargetTrackingScaling"
    resource_id                                       = aws_appautoscaling_target.task_replica_targets.resource_id
    scalable_dimension                                = aws_appautoscaling_target.task_replica_targets.scalable_dimension
    service_namespace                                 = aws_appautoscaling_target.task_replica_targets.service_namespace

    target_tracking_scaling_policy_configuration {
        predefined_metric_specification {
            predefined_metric_type                        = "ECSServiceAverageCPUUtilization"
        }
        scale_in_cooldown                             = local.scale_in_cooldown
        scale_out_cooldown                            = local.scale_out_cooldown
        target_value                                  = local.scale_target
    }
}


resource "aws_lb_target_group" "service_target_group" {
    name                                            = "${var.cluster_config.name}-${var.service_config.name}"
    port                                            = var.service_config.port
    protocol                                        = "HTTP"
    vpc_id                                          = var.vpc_config.vpc_id

    healthcheck {
        enabled                                     = true
        path                                        = var.service_config.healthcheck_endpoint
        port                                        = var.service_config.port
        protocol                                    = "HTTP"
        timeout                                     = local.healthcheck_timeout   
        healthy_threshold                           = local.healthy_threshold
        unhealthy_threshold                         = local.unhealthy_threshold
    }
}


resource "aws_ecs_task_definition" "task_definition" {
    family                                          = "${var.service_config.name}-task-definition"
    requires_compatibilities                        = [
                                                        "FARGATE"
                                                    ]
    network_mode                                    = "awsvpc"
    execution_role_arn                              = var.task_execution_role_arn
    cpu                                             = local.task_cpu
    memory                                          = local.task_memory
    container_definitions                           = jsonencode(
                                                        jsondecode(
                                                            file("${path.module}/../${task_definition}")
                                                        )
                                                    )

    volume {
        name                                            = "${var.service_config.name}"
        host_path                                       = "/ecs/${var.service_config.name}"
    }
}


resource "aws_ecs_service" "service" {
    name                                                = var.service_config.name
    cluster                                             = module.cluster.cluster.id
    task_definition                                     = aws_ecs_task_definition.task_definition.arn
    desired_count                                       = var.service_config.desired_count
    deployment_maximum_percent                          = local.service_max_percent
    deployment_minimum_healthy_percent                  = local.service_min_percent
    health_check_grace_period_seconds                   = local.healthcheck
    launch_type                                         = "FARGATE"

    network_configuration {
        subnets                                         = var.service_config.public ? var.vpc_config.public_subnets : var.vpc_config.private_subnets
        security_groups                                 = var.service_config.security_group_ids
        assign_public_ip                                = var.service_config.public
    }
    load_balancer {
        target_group_arn                                = aws_lb_target_group.service_target_group.arn
        container_name                                  = var.service_config.name
        container_port                                  = var.service_config.port
    }
    service_registries {
        registry_arn                                    = aws_service_discovery_service.discovery_serice.arn
        port                                            = var.service_config.port
    }

}

resource "aws_service_discovery_service" "discovery_serice" {
    name = "${var.service_config.name}-discovery-serrvice"

    dns_config {
        namespace_id = module.cluster.cluster_namespace.id

        dns_records {
            ttl                                         = 10
            type                                        = "A"
        }
        dns_records {
            ttl                                         = 10
            type                                        = "SRV"
        }

        routing_policy                                  = "MULTIVALUE"
    }

    health_check_custom_config {
        failure_threshold                               = 1
    }
}