output "aws_ecs_cluster_name" {
    value = aws_ecs_cluster.server_cluster.name
}

output "rds_identifier" {
    value = aws_db_instance.dhcp_server_db.id
}
