output "bind_config_bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}

output "bind_config_bucket_arn" {
  value = aws_s3_bucket.config_bucket.arn
}

output "bind_config_bucket_key_arn" {
  value = aws_kms_key.config_bucket_key.arn
}

output "ecs" {
  value = {
    cluster_name         = module.dns_dhcp_common.ecs.cluster_name
    service_name         = module.dns_dhcp_common.ecs.service_name
    service_arn          = module.dns_dhcp_common.ecs.service_arn
    task_definition_name = aws_ecs_task_definition.server_task.family
  }
}

output "ecr" {
  value = module.dns_dhcp_common.ecr
}
