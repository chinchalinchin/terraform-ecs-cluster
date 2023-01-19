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