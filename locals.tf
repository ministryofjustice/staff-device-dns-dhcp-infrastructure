locals {
  env               = terraform.workspace
  dns_dhcp_vpc_cidr = "10.180.80.0/22"

  allowed_ip_ranges                       = nonsensitive(jsondecode(data.aws_ssm_parameter.allowed_ip_ranges.value))
  azure_federation_metadata_url           = data.aws_ssm_parameter.azure_federation_metadata_url.value
  bastion_allowed_ingress_ip              = nonsensitive(data.aws_ssm_parameter.bastion_allowed_ingress_ip.value)
  bastion_allowed_egress_ip               = nonsensitive(data.aws_ssm_parameter.bastion_allowed_egress_ip.value)
  byoip_pool_id                           = nonsensitive(data.aws_ssm_parameter.byoip_pool_id.value)
  corsham_vm_ip                           = nonsensitive(data.aws_ssm_parameter.corsham_vm_ip.value)
  dhcp_transit_gateway_id                 = nonsensitive(data.aws_ssm_parameter.dhcp_transit_gateway_id.value)
  dns_load_balancer_private_ip_eu_west_2a = nonsensitive(data.aws_ssm_parameter.dns_load_balancer_private_ip_eu_west_2a.value)
  dns_load_balancer_private_ip_eu_west_2b = nonsensitive(data.aws_ssm_parameter.dns_load_balancer_private_ip_eu_west_2b.value)
  dns_route53_resolver_ip_eu_west_2a      = nonsensitive(data.aws_ssm_parameter.dns_route53_resolver_ip_eu_west_2a.value)
  dns_route53_resolver_ip_eu_west_2b      = nonsensitive(data.aws_ssm_parameter.dns_route53_resolver_ip_eu_west_2b.value)
  enable_corsham_test_bastion             = data.aws_ssm_parameter.enable_corsham_test_bastion.value
  enable_load_testing                     = tobool(data.aws_ssm_parameter.enable_load_testing.value)
  enable_rds_admin_bastion                = tobool(data.aws_ssm_parameter.enable_rds_admin_bastion.value)
  enable_rds_servers_bastion              = tobool(data.aws_ssm_parameter.enable_rds_servers_bastion.value)
  model_office_vm_ip                      = nonsensitive(data.aws_ssm_parameter.model_office_vm_ip.value)
  number_of_load_testing_nodes            = tonumber(data.aws_ssm_parameter.number_of_load_testing_nodes.value)
  pdns_ips                                = data.aws_ssm_parameter.pdns_ips.value
  pdns_ips_list                           = nonsensitive(jsondecode(data.aws_ssm_parameter.pdns_ips_list.value))
  shared_services_account_id              = nonsensitive(data.aws_ssm_parameter.shared_services_account_id.value)
  transit_gateway_route_table_id          = nonsensitive(data.aws_ssm_parameter.transit_gateway_route_table_id.value)
  vpn_hosted_zone_id                      = nonsensitive(data.aws_ssm_parameter.vpn_hosted_zone_id.value)
  vpn_hosted_zone_domain                  = nonsensitive(data.aws_ssm_parameter.vpn_hosted_zone_domain.value)

  s3-mojo_file_transfer_assume_role_arn = data.terraform_remote_state.staff-device-shared-services-infrastructure.outputs.s3-mojo_file_transfer_assume_role_arn
  xsiam_secrets_version_development     = "9e0de226-ed1a-4dbc-a42a-e549ff86fb19"
  xsiam_secrets_version_pre_production  = "f3680e16-7395-4c82-947a-be9b5e09b79c"
  xsiam_secrets_version_production      = "a83ace3e-b154-4992-bde2-bf72e2aa9950"

  ## for resources which requires the tags map without the "Name" value
  ## It uses the "name" attribute internally and concatenates with other attributes
  tags_admin_minus_name = { for k, v in module.admin_label.tags : k => v if !contains(["Name"], k) }
  tags_dhcp_minus_name  = { for k, v in module.dhcp_label.tags : k => v if !contains(["Name"], k) }
  tags_dns_minus_name   = { for k, v in module.dns_label.tags : k => v if !contains(["Name"], k) }


  ssm_arns = {
    DNS_HEALTH_CHECK_URL                        = aws_ssm_parameter.dns_health_check_url.arn
  }

  secret_manager_arns = {
    codebuild_dhcp_env_admin_db                  = aws_secretsmanager_secret.codebuild_dhcp_env_admin_db.arn
    codebuild_dhcp_env_db                        = aws_secretsmanager_secret.codebuild_dhcp_env_db.arn
    staff_device_dhcp_sentry_dsn                 = aws_secretsmanager_secret.staff_device_dhcp_sentry_dsn.arn
    staff_device_dns_sentry_dsn                  = aws_secretsmanager_secret.staff_device_dns_sentry_dsn_1.arn
    staff_device_admin_sentry_dsn                = aws_secretsmanager_secret.staff_device_admin_sentry_dsn_1.arn
    codebuild_dhcp_env_admin_api                 = aws_secretsmanager_secret.codebuild_dhcp_env_admin_api.arn
    staff_device_admin_env_cognito_client_id     = aws_secretsmanager_secret.staff_device_admin_env_cognito_client_id.arn
    staff_device_admin_env_cognito_client_secret = aws_secretsmanager_secret.staff_device_admin_env_cognito_client_secret.arn
    staff_device_admin_env_cognito_userpool_id   = aws_secretsmanager_secret.staff_device_admin_env_cognito_userpool_id.arn
  }
}
