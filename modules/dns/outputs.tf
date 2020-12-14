output "bind_config_bucket_name" {
  value = module.dns_dhcp_common.s3.bucket_id
}

output "bind_config_bucket_arn" {
  value = module.dns_dhcp_common.s3.bucket_arn
}

output "bind_config_bucket_key_arn" {
  value = module.dns_dhcp_common.s3.bucket_key_arn
}

output "ecs" {
  value = {
    cluster_name         = aws_ecs_cluster.server_cluster.name
    cluster_id           = aws_ecs_cluster.server_cluster.id
    service_name         = aws_ecs_service.service.name
    service_arn          = aws_ecs_service.service.id
    task_definition_name = aws_ecs_task_definition.server_task.family
  }
}

output "ecr" {
  value = module.dns_dhcp_common.ecr
}

output "nlb" {
  value = {
    name = aws_lb.load_balancer.id
    arn  = aws_lb.load_balancer.arn
  }
}
