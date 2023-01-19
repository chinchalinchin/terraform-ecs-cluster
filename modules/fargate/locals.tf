locals {
    cw_log_retention                                    = 14
    eks_tags                                            = {
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
}