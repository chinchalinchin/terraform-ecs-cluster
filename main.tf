module "cluster" {
  source                                  = "./modules/cluster"
  some_var                                = ""
}


module "task" {
  depends_on                              = [
                                            module.cluster
                                          ]
  source                                  = "./modules/task"
}

