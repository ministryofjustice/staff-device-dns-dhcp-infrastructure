locals {
  dhcp_log_metrics = [
    "FATAL",
    "ERROR",
    "WARN",
    "HTTP_PREMATURE_CONNECTION_TIMEOUT_OCCURRED",
    "ALLOC_ENGINE_V4_ALLOC_ERROR",
    "ALLOC_ENGINE_V4_ALLOC_FAIL",
    "ALLOC_ENGINE_V4_ALLOC_FAIL_CLASSES",
    "DHCP4_PACKET_NAK_0001",
    "HA_SYNC_FAILED",
    "HA_HEARTBEAT_COMMUNICATIONS_FAILED",
    "HA_DHCP_DISABLE_COMMUNICATIONS_FAILED",
    "Config reload failed",
    "Configuration successful"
  ]
}

module "dhcp_standby" {
  source = "./modules/dhcp_standby"

  dhcp_db_host                        = module.dhcp.db_host
  dhcp_log_search_metric_filters      = var.enable_dhcp_cloudwatch_log_metrics == true ? local.dhcp_log_metrics : []
  dhcp_repository_url                 = module.dhcp.ecr.repository_url
  dhcp_server_cluster_id              = module.dhcp.ecs.cluster_id
  dhcp_server_db_name                 = module.dhcp.rds.name
  dhcp_server_security_group_id       = module.dhcp.ec2.dhcp_server_security_group_id
  ecs_task_execution_role_arn         = module.dhcp.iam.task_execution_role_arn
  ecs_task_role_arn                   = module.dhcp.iam.task_role_arn
  kea_config_bucket_name              = module.dhcp.kea_config_bucket_name
  load_balancer_private_ip_eu_west_2a = var.dhcp_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b = var.dhcp_load_balancer_private_ip_eu_west_2b
  metrics_namespace                   = var.metrics_namespace
  nginx_repository_url                = module.dhcp.ecr.nginx_repository_url
  prefix                              = module.dhcp_standby_label.id
  private_subnets                     = module.servers_vpc.private_subnets
  short_prefix                        = module.dhcp_label.stage # avoid 32 char limit on certain resources
  tags                                = module.dhcp_standby_label.tags
  vpc_cidr                            = local.dns_dhcp_vpc_cidr
  vpc_id                              = module.servers_vpc.vpc_id
  env                                 = var.env
  


  providers = {
    aws = aws.env
  }

  depends_on = [
    module.dhcp
  ]
}

module "dhcp" {
  source                               = "./modules/dhcp"
  shared_services_account_id           = var.shared_services_account_id
  admin_local_development_domain_affix = var.admin_local_development_domain_affix
  dhcp_log_search_metric_filters       = var.enable_dhcp_cloudwatch_log_metrics == true ? local.dhcp_log_metrics : []
  load_balancer_private_ip_eu_west_2a  = var.dhcp_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b  = var.dhcp_load_balancer_private_ip_eu_west_2b
  metrics_namespace                    = var.metrics_namespace
  prefix                               = module.dhcp_label.id
  private_subnets                      = module.servers_vpc.private_subnets
  sentry_dsn                           = var.dhcp_sentry_dsn
  short_prefix                         = module.dhcp_label.stage # avoid 32 char limit on certain resources
  tags                                 = module.dhcp_label.tags
  vpc_cidr                             = local.dns_dhcp_vpc_cidr
  vpc_id                               = module.servers_vpc.vpc_id
  vpn_hosted_zone_domain               = var.vpn_hosted_zone_domain
  vpn_hosted_zone_id                   = var.vpn_hosted_zone_id
  env                                  = var.env




  providers = {
    aws = aws.env
  }

  depends_on = [
    module.servers_vpc
  ]
}
