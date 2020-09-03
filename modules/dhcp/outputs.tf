output "rds_identifier" {
  value = aws_db_instance.dhcp_server_db.id
}

output "kea_config_bucket_arn" {
  value = module.dns_dhcp_common.s3.config_bucket_arn
}

output "kea_config_bucket_name" {
  value = module.dns_dhcp_common.s3.config_bucket_name
}

output "dhcp_cluster_name" {
  value = module.dns_dhcp_common.ecs.cluster_name
}

output "load_balancer" {
  value = module.dns_dhcp_common.nlb.name
}
