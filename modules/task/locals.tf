locals {
    autoscale_min                                       = 1
    autoscale_max                                       = 15
    scale_in_cooldown                                   = 10
    scale_out_cooldown                                  = 10
    scale_target                                        = 70
    eks_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ecs-fargate-cluster"
                                                            Owned           = "bah-625518"
                                                            Service         = "ecs"

                                                        }
}