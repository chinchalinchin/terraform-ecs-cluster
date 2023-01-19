cluster_config = {
    name                    = "autolib-fargate-cluster"
    namespace               = "autolib.net"
}

service_config = {
    name                    = "autolib-service"
    port                    = 80
    desired_count           = 3
    public                  = true
    security_group_ids      = [

    ]
    healthcheck_endpoint    = "/"
}

task_definition             = "task_definition.json"

region                      = "us-east-1"

# USE TF_VAR_* environment variables for: vpc_config, task_execution_role