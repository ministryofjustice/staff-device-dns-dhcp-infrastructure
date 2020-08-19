output "aws_ecs_cluster_name" {
    value = aws_ecs_cluster.server_cluster.name
}

output "rds_identifier" {
    value = aws_db_instance.dhcp_server_db.id
}

output "load_balancer" {
    value = aws_lb.load_balancer.id
}

output "kea_config_bucket_arn" {
    value = aws_s3_bucket.config_bucket.arn
}

output "kea_config_bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}
