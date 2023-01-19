module "cluster" {
  source                                  = "./modules/cluster"
  cluster_config                          = var.cluster_config
  vpc_config                              = var.vpc_config        
}


module "task" {
  depends_on                              = [
                                            module.cluster
                                          ]
  source                                  = "./modules/task"
  cluster_id                              = module.cluster.cluster_id
  namespace_id                            = module.cluster.cluster_namespace_id
  vpc_config                              = var.vpc_config  
  service_config                          = var.service_config
  task_definition                         = var.task_definition
  task_execution_role_arn                 = var.task_execution_role_arn
}

