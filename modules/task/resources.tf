resource "aws_appautoscaling_target" "task_replica_targets" {
  service_namespace                                 = "ecs"
  scalable_dimension                                = "ecs:service:DesiredCount"
  resource_id                                       = "service/${aws_ecs_cluster.example.name}/${aws_ecs_service.example.name}"
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
    scale_in_cooldown                               = local.scale_in_cooldown
    scale_out_cooldown                              = local.scale_out_cooldown
    target_value = 70
  }
}