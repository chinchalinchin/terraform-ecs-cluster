output "cluster_namespace_id" {
    value                                   = aws_service_discovery_private_dns_namespace.cluster_namespace.id
}


output "cluster_namespace_arn" {
    value                                   = aws_service_discovery_private_dns_namespace.cluster_namespace.arn
}


output "cluster_id" {
    value                                   = aws_ecs_cluster.cluster.id
}


output "cluster_arn" {
    value                                   = aws_ecs_cluster.cluster.arn
}