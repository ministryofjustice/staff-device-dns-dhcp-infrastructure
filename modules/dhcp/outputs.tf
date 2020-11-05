output "rds_identifier" {
  value = aws_db_instance.dhcp_server_db.id
}

output "kea_config_bucket_arn" {
  value = aws_s3_bucket.config_bucket.arn
}

output "kea_config_bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}

output "ecs" {
  value = {
    cluster_name         = module.dns_dhcp_common.ecs.cluster_name
    service_name         = module.dns_dhcp_common.ecs.service_name
    service_arn          = module.dns_dhcp_common.ecs.service_arn
    task_definition_name = aws_ecs_task_definition.server_task.family
  }
}

output "rds" {
  value = {
    endpoint = aws_db_instance.dhcp_server_db.endpoint
  }
}

output "ecr" {
  value = module.dns_dhcp_common.ecr
}

output "load_balancer" {
  value = module.dns_dhcp_common.nlb.name
}

output "http_api_load_balancer_arn" {
  value = aws_lb.http_api_load_balancer.arn
}

output "dhcp_config_bucket_key_arn" {
  value = aws_kms_key.config_bucket_key.arn
}

output "db_name" {
  value = aws_db_instance.dhcp_server_db.name
}

output "db_host" {
  value = aws_route53_record.dhcp_db.fqdn
}

output "db_port" {
  value = aws_db_instance.dhcp_server_db.port
}
