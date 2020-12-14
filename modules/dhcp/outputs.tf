output "rds_identifier" {
  value = aws_db_instance.dhcp_server_db.id
}

output "kea_config_bucket_arn" {
  value = module.dns_dhcp_common.s3.bucket_arn
}

output "kea_config_bucket_name" {
  value = module.dns_dhcp_common.s3.bucket_id
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

output "rds" {
  value = {
    endpoint = aws_db_instance.dhcp_server_db.endpoint
    name     = aws_db_instance.dhcp_server_db.name
  }
}

output "iam" {
  value = {
    task_execution_role_arn = module.dns_dhcp_common.iam.ecs_execution_role_arn
    task_role_arn           = module.dns_dhcp_common.iam.ecs_task_role_arn
  }
}

output "nlb" {
  value = {
    name = aws_lb.load_balancer.id
    arn  = aws_lb.load_balancer.arn
  }
}

output "cloudwatch" {
  value = module.dns_dhcp_common.cloudwatch
}

output "ecr" {
  value = module.dns_dhcp_common.ecr
}

output "load_balancer" {
  value = aws_lb.load_balancer.name
}

output "http_api_load_balancer_arn" {
  value = aws_lb.http_api_load_balancer.arn
}

output "dhcp_config_bucket_key_arn" {
  value = module.dns_dhcp_common.s3.bucket_key_arn
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

output "ec2" {
  value = {
    dhcp_server_security_group_id = aws_security_group.dhcp_server.id
  }
}
