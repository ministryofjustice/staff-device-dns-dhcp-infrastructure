terraform {
  backend "s3" {
    bucket         = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-state"
    dynamodb_table = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-lock-table"
    region         = "eu-west-2"
  }
}

provider "mysql" {
  endpoint = module.dhcp.rds.endpoint
  username = var.dhcp_db_username
  password = var.dhcp_db_password
}

provider "aws" {

  alias = "env"
  assume_role {
    role_arn = var.assume_role
  }
}

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

module "dhcp_label" {
  source       = "./modules/label"
  service_name = "dhcp"
  owner_email  = var.owner_email
}

module "dhcp_standby_label" {
  source       = "./modules/label"
  service_name = "dhcp-standby"
  owner_email  = var.owner_email
}

module "heartbeat_label" {
  source       = "./modules/label"
  service_name = "dns-dhcp-heartbeat"
  owner_email  = var.owner_email
}

module "admin_label" {
  source       = "./modules/label"
  service_name = "admin"
  owner_email  = var.owner_email
}

module "auth_label" {
  source       = "./modules/label"
  service_name = "auth"
  owner_email  = var.owner_email
}

data "aws_region" "current_region" {}
data "aws_caller_identity" "shared_services_account" {}

locals {
  dns_dhcp_vpc_cidr = "10.180.80.0/22"
}

module "servers_vpc" {
  source = "./modules/servers_vpc"

  byoip_pool_id                          = var.byoip_pool_id
  cidr_block                             = "10.180.80.0/22"
  cidr_block_new_bits                    = 2
  corsham_vm_ip                          = var.corsham_vm_ip
  dhcp_transit_gateway_id                = var.dhcp_transit_gateway_id
  enable_dhcp_transit_gateway_attachment = var.enable_dhcp_transit_gateway_attachment
  model_office_vm_ip                     = var.model_office_vm_ip
  pdns_ips                               = var.pdns_ips_list
  prefix                                 = module.dhcp_label.id
  region                                 = data.aws_region.current_region.id
  tags                                   = module.dhcp_label.tags
  transit_gateway_route_table_id         = var.transit_gateway_route_table_id

  providers = {
    aws = aws.env
  }
}

module "admin_vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  prefix     = "${module.dhcp_label.id}-admin"
  region     = data.aws_region.current_region.id
  tags       = module.admin_label.tags

  providers = {
    aws = aws.env
  }
}

module "dhcp_standby" {
  source = "./modules/dhcp_standby"

  dhcp_db_host                        = module.dhcp.db_host
  dhcp_db_password                    = var.dhcp_db_password
  dhcp_db_username                    = var.dhcp_db_username
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
  dhcp_db_password                     = var.dhcp_db_password
  dhcp_db_username                     = var.dhcp_db_username
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

  providers = {
    aws = aws.env
  }

  depends_on = [
    module.servers_vpc
  ]
}

module "admin" {
  source = "./modules/admin"

  admin_db_backup_retention_period     = var.admin_db_backup_retention_period
  admin_db_password                    = var.admin_db_password
  admin_db_username                    = var.admin_db_username
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
  private_zone                         = var.dns_private_zone
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
  api_basic_auth_username              = var.api_basic_auth_username
  api_basic_auth_password              = var.api_basic_auth_password
  shared_services_account_id           = var.shared_services_account_id

  depends_on = [
    module.admin_vpc
  ]

  providers = {
    aws = aws.env
  }
}

module "authentication" {
  source = "./modules/authentication"

  admin_url                     = module.admin.admin_url
  azure_federation_metadata_url = var.azure_federation_metadata_url
  enable_authentication         = var.enable_authentication
  prefix                        = module.dhcp_label.id
  region                        = data.aws_region.current_region.id
  tags                          = module.auth_label.tags
  vpn_hosted_zone_domain        = var.vpn_hosted_zone_domain

  providers = {
    aws = aws.env
  }
}

module "dns" {
  source = "./modules/dns"

  dns_route53_resolver_ip_eu_west_2a  = var.dns_route53_resolver_ip_eu_west_2a
  dns_route53_resolver_ip_eu_west_2b  = var.dns_route53_resolver_ip_eu_west_2b
  load_balancer_private_ip_eu_west_2a = var.dns_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b = var.dns_load_balancer_private_ip_eu_west_2b
  prefix                              = module.dns_label.id
  sentry_dsn                          = var.dns_sentry_dsn
  short_prefix                        = module.dns_label.stage
  subnets                             = module.servers_vpc.private_subnets
  tags                                = module.dns_label.tags
  vpc_cidr                            = local.dns_dhcp_vpc_cidr
  vpc_id                              = module.servers_vpc.vpc_id
  shared_services_account_id          = var.shared_services_account_id

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }
}

module "bastion_label" {
  source        = "./modules/label"
  service_name  = "dns-bastion"
  owner_email   = var.owner_email
}

module "bastion" {
  source          = "./modules/bastion"
  prefix          = module.bastion_label.id
  vpc_id          = module.servers_vpc.vpc.vpc_id
  vpc_cidr_block  = module.servers_vpc.vpc.vpc_cidr_block
  private_subnets = module.servers_vpc.vpc.private_subnets
  //bastion_allowed_ingress_ip = var.bastion_allowed_ingress_ip
  tags = module.bastion_label.tags

  providers = {
    aws = aws.env
  }

  depends_on = [module.servers_vpc]

  count = var.enable_bastion_jumpbox == true ? 1 : 0
}

module "corsham_test_bastion" {
  source = "./modules/corsham_test"

  bastion_allowed_egress_ip  = var.bastion_allowed_egress_ip
  bastion_allowed_ingress_ip = var.bastion_allowed_ingress_ip
  corsham_vm_ip              = var.corsham_vm_ip
  route_table_id             = module.servers_vpc.public_route_table_ids[0]
  subnets                    = module.servers_vpc.public_subnets
  tags                       = module.dhcp_label.tags
  transit_gateway_id         = var.dhcp_transit_gateway_id
  vpc_id                     = module.servers_vpc.vpc_id

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }

  count = var.enable_corsham_test_bastion == true ? 1 : 0
}


module "dns_label" {
  source       = "./modules/label"
  service_name = "dns"
  owner_email  = var.owner_email
}

module "dhcp_dns_vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"
  prefix = "staff-device-dns-dhcp-${terraform.workspace}"
  region = data.aws_region.current_region.id
  tags   = module.dhcp_label.tags
  vpc_id = module.servers_vpc.vpc_id

  providers = {
    aws = aws.env
  }
}

module "admin_vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"
  prefix = "staff-device-admin-${terraform.workspace}"
  region = data.aws_region.current_region.id
  tags   = module.admin_label.tags
  vpc_id = module.admin_vpc.vpc_id

  providers = {
    aws = aws.env
  }
}
