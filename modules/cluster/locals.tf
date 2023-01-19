locals {
    all_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ecs-fargate-cluster"
                                                            Owned           = "bah-625518"
                                                        }
    alb_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ecs-fargate-cluster"
                                                            Owned           = "bah-625518"
                                                            Service         = "alb"
                                                        }
    cw_log_retention                                    = 14
    ecs_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ecs-fargate-cluster"
                                                            Owned           = "bah-625518"
                                                            Service         = "ecs"

                                                        }
    kms_tags                                            = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ecs-fargate-cluster"
                                                            Owned           = "bah-625518"
                                                            Service         = "kms"
                                                        }
    s3_tags                                             = {
                                                            Organization    = "BrightLabs"
                                                            Team            = "AutomationLibrary"
                                                            Project         = "aws-ecs-fargate-cluster"
                                                            Owned           = "bah-625518"
                                                            Service         = "s3"
                                                        }
}