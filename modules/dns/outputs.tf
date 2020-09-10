output "bind_config_bucket_name" {
  value = module.dns_dhcp_common.s3.config_bucket_name
}

output "bind_config_bucket_arn" {
  value = module.dns_dhcp_common.s3.config_bucket_arn
}
