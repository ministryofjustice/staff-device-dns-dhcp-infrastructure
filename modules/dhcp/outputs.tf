output "rds_identifier" {
  value = aws_db_instance.dhcp_server_db.id
}

output "kea_config_bucket_arn" {
  value = module.dns_dhcp_common.s3.config_bucket_arn
}

output "kea_config_bucket_name" {
  value = module.dns_dhcp_common.s3.config_bucket_name
}

output "ecs" {
  value = {
    cluster_name = module.dns_dhcp_common.ecs.cluster_name
    service_name = module.dns_dhcp_common.ecs.service_name
    service_arn = module.dns_dhcp_common.ecs.service_arn
    task_definition_name = aws_ecs_task_definition.server_task.family
  }
}

output "ecr" {
  value = module.dns_dhcp_common.ecr
}

output "load_balancer" {
  value = module.dns_dhcp_common.nlb.name
}
