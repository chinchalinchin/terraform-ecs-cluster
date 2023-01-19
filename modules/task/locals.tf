locals {
    autoscale_min                                       = 1
    autoscale_max                                       = 15
    scale_in_cooldown                                   = 10
    scale_out_cooldown                                  = 10
    scale_target                                        = 70
    service_max_percent                                 = 200
    service_min_percent                                 = 100
    healthcheck                                         = 30
    healthcheck_timeout                                 = 5
    healthy_threshold                                   = 2
    unhealthy_threshold                                 = 2
    task_cpu                                            = 1024
    task_memory                                         = 2048
    eks_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ecs-fargate-cluster"
                                                            Owned           = "bah-625518"
                                                            Service         = "ecs"

                                                        }
}