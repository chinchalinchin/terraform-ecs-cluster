variable "cluster_config" {
    description                         = "Cluster configuration for deployment"
    type = object({
        name                            = string
        namespace                       = string
    })       
    default = {
        name                            = "automation-library-cluster"
        namespace                       = "autolib.net"
    }
}


variable "service_config" {
    description                         = "Service configuration for deployment"
    type = object({
        name                            = string
        port                            = number
        desired_count                   = number
        public                          = bool
        security_group_ids              = list(string)
        healthcheck_endpoint            = string
    })
    default = {
        name                            = "autolib-service"
        port                            = 80
        desired_count                   = 2
        public                          = true
        security_group_ids              = []
        healthcheck_endpoint            = "/"
    }
}


variable "vpc_config" {
    description                         = "VPC configuration for deployment"
    type = object({
        id                              = string
        security_group_ids              = list(string)
        public_subnet_ids               = list(string)
        private_subnet_ids              = list(string)
        cidr_block                      = string
    })
    default                             = null
}


variable "task_definition" {
    description                         = "File path to Task Definition JSON"
    type                                = string
    default                             = "task_definition.json"           
}


variable "task_execution_role_arn" {
    description                         = "Role ARN for the ECS task to assume"
    type                                = string
}