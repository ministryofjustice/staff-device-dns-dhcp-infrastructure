module "admin" {
  source = "./modules/admin"

  admin_db_backup_retention_period     = var.admin_db_backup_retention_period
  admin_db_password                    = jsondecode(data.aws_secretsmanager_secret_version.codebuild_dhcp_env_admin_db.secret_string)["password"]
  admin_db_username                    = jsondecode(data.aws_secretsmanager_secret_version.codebuild_dhcp_env_admin_db.secret_string)["username"]
  admin_local_development_domain_affix = var.admin_local_development_domain_affix
  bind_config_bucket_arn               = module.dns.bind_config_bucket_arn
  bind_config_bucket_key_arn           = module.dns.bind_config_bucket_key_arn
  bind_config_bucket_name              = module.dns.bind_config_bucket_name
  cognito_user_pool_client_id          = module.authentication.cognito_user_pool_client_id
  cognito_user_pool_client_secret      = module.authentication.cognito_user_pool_client_secret
  cognito_user_pool_domain             = module.authentication.cognito_user_pool_domain
  cognito_user_pool_id                 = module.authentication.cognito_user_pool_id
  dhcp_cluster_name                    = module.dhcp.ecs.cluster_name
  dhcp_config_bucket_key_arn           = module.dhcp.dhcp_config_bucket_key_arn
  dhcp_http_api_load_balancer_arn      = module.dhcp.http_api_load_balancer_arn
  dhcp_service_arn                     = module.dhcp.ecs.service_arn
  dhcp_service_name                    = module.dhcp.ecs.service_name
  dns_cluster_name                     = module.dns.ecs.cluster_name
  dns_service_name                     = module.dns.ecs.service_name
  kea_config_bucket_arn                = module.dhcp.kea_config_bucket_arn
  kea_config_bucket_name               = module.dhcp.kea_config_bucket_name
  pdns_ips                             = var.pdns_ips
  prefix                               = "${module.dhcp_label.id}-admin"
  private_zone                         = data.aws_ssm_parameter.dns_private_zone.value
  region                               = data.aws_region.current_region.id
  secret_key_base                      = "tbc"
  sentry_dsn                           = var.admin_sentry_dsn
  short_prefix                         = module.dhcp_label.stage # avoid 32 char limit on certain resources
  subnet_ids                           = module.admin_vpc.public_subnets
  tags                                 = module.admin_label.tags
  vpc_id                               = module.admin_vpc.vpc_id
  vpn_hosted_zone_domain               = var.vpn_hosted_zone_domain
  vpn_hosted_zone_id                   = var.vpn_hosted_zone_id
  allowed_ip_ranges                    = var.allowed_ip_ranges
  api_basic_auth_username              = jsondecode(data.aws_secretsmanager_secret_version.codebuild_dhcp_env_admin_api.secret_string)["basic_auth_username"]
  api_basic_auth_password              = jsondecode(data.aws_secretsmanager_secret_version.codebuild_dhcp_env_admin_api.secret_string)["basic_auth_password"]
  shared_services_account_id           = var.shared_services_account_id
  env                                  = var.env
  secret_arns                          = local.secret_manager_arns

  depends_on = [
    module.admin_vpc
  ]

  providers = {
    aws = aws.env
  }
}
