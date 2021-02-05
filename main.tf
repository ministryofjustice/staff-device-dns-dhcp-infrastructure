terraform {
  required_version = "> 0.13.0"

  backend "s3" {
    bucket         = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-state"
    dynamodb_table = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-lock-table"
    region         = "eu-west-2"
  }
}

provider "mysql" {
  version  = "~> 1.9"
  endpoint = module.dhcp.rds.endpoint
  username = var.dhcp_db_username
  password = var.dhcp_db_password
}

provider "template" {
  version = "~> 2.1"
}

provider "tls" {
  version = "> 2.1"
}

provider "aws" {
  version = "~> 3.10"
  alias   = "env"
  assume_role {
    role_arn = var.assume_role
  }
}

provider "local" {
  version = "~> 1.4"
}

locals {
  publicly_accessible = terraform.workspace == "production" ? false : true
}

module "dhcp_label" {
  source       = "./modules/label"
  service_name = "dhcp"
}

module "dhcp_standby_label" {
  source       = "./modules/label"
  service_name = "dhcp-standby"
}

data "aws_region" "current_region" {}
data "aws_caller_identity" "shared_services_account" {}

locals {
  dns_dhcp_vpc_cidr = "10.180.80.0/22"
}

module "servers_vpc" {
  source                                 = "./modules/servers_vpc"
  prefix                                 = module.dhcp_label.id
  region                                 = data.aws_region.current_region.id
  cidr_block                             = "10.180.80.0/22"
  cidr_block_new_bits                    = 2
  byoip_pool_id                          = var.byoip_pool_id
  pdns_ips                               = var.pdns_ips_list
  enable_dhcp_transit_gateway_attachment = var.enable_dhcp_transit_gateway_attachment
  tags                                   = module.dhcp_label.tags
  dhcp_transit_gateway_id                = var.dhcp_transit_gateway_id
  transit_gateway_route_table_id         = var.transit_gateway_route_table_id

  providers = {
    aws = aws.env
  }
}

module "admin_vpc" {
  source     = "./modules/vpc"
  prefix     = "${module.dhcp_label.id}-admin"
  region     = data.aws_region.current_region.id
  cidr_block = "10.0.0.0/16"

  providers = {
    aws = aws.env
  }
}

module "dhcp_standby" {
  source                              = "./modules/dhcp_standby"
  prefix                              = module.dhcp_standby_label.id
  short_prefix                        = module.dhcp_label.stage # avoid 32 char limit on certain resources
  private_subnets                     = module.servers_vpc.private_subnets
  tags                                = module.dhcp_standby_label.tags
  vpc_id                              = module.servers_vpc.vpc_id
  dhcp_db_password                    = var.dhcp_db_password
  dhcp_db_username                    = var.dhcp_db_username
  load_balancer_private_ip_eu_west_2a = var.dhcp_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b = var.dhcp_load_balancer_private_ip_eu_west_2b
  vpc_cidr                            = local.dns_dhcp_vpc_cidr
  nginx_repository_url                = module.dhcp.ecr.nginx_repository_url
  dhcp_repository_url                 = module.dhcp.ecr.repository_url
  dhcp_db_host                        = module.dhcp.db_host
  dhcp_server_db_name                 = module.dhcp.rds.name
  ecs_task_execution_role_arn         = module.dhcp.iam.task_execution_role_arn
  ecs_task_role_arn                   = module.dhcp.iam.task_role_arn
  dhcp_server_cluster_id              = module.dhcp.ecs.cluster_id
  kea_config_bucket_name              = module.dhcp.kea_config_bucket_name
  dhcp_server_security_group_id       = module.dhcp.ec2.dhcp_server_security_group_id

  providers = {
    aws = aws.env
  }

  depends_on = [
    module.dhcp
  ]
}

locals {
  metrics_namespace = "Kea-DHCP"
}

module "dhcp" {
  source                                       = "./modules/dhcp"
  prefix                                       = module.dhcp_label.id
  private_subnets                              = module.servers_vpc.private_subnets
  tags                                         = module.dhcp_label.tags
  vpc_id                                       = module.servers_vpc.vpc_id
  dhcp_db_password                             = var.dhcp_db_password
  dhcp_db_username                             = var.dhcp_db_username
  load_balancer_private_ip_eu_west_2a          = var.dhcp_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b          = var.dhcp_load_balancer_private_ip_eu_west_2b
  vpn_hosted_zone_id                           = var.vpn_hosted_zone_id
  vpn_hosted_zone_domain                       = var.vpn_hosted_zone_domain
  short_prefix                                 = module.dhcp_label.stage # avoid 32 char limit on certain resources
  is_publicly_accessible                       = local.publicly_accessible
  vpc_cidr                                     = local.dns_dhcp_vpc_cidr
  admin_local_development_domain_affix         = var.admin_local_development_domain_affix
  metrics_namespace                            = local.metrics_namespace
  dhcp_log_search_metric_filters = var.enable_dhcp_cloudwatch_log_metrics == true ? [
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
  ] : []

  providers = {
    aws = aws.env
  }

  depends_on = [
    module.servers_vpc
  ]
}

module "admin" {
  source                               = "./modules/admin"
  prefix                               = "${module.dhcp_label.id}-admin"
  short_prefix                         = module.dhcp_label.stage # avoid 32 char limit on certain resources
  tags                                 = module.dhcp_label.tags
  vpc_id                               = module.admin_vpc.vpc_id
  admin_db_password                    = var.admin_db_password
  admin_db_username                    = var.admin_db_username
  subnet_ids                           = module.admin_vpc.public_subnets
  sentry_dsn                           = var.sentry_dsn
  secret_key_base                      = "tbc"
  kea_config_bucket_arn                = module.dhcp.kea_config_bucket_arn
  kea_config_bucket_name               = module.dhcp.kea_config_bucket_name
  region                               = data.aws_region.current_region.id
  vpn_hosted_zone_id                   = var.vpn_hosted_zone_id
  vpn_hosted_zone_domain               = var.vpn_hosted_zone_domain
  admin_db_backup_retention_period     = var.admin_db_backup_retention_period
  cognito_user_pool_id                 = module.authentication.cognito_user_pool_id
  cognito_user_pool_domain             = module.authentication.cognito_user_pool_domain
  cognito_user_pool_client_id          = module.authentication.cognito_user_pool_client_id
  cognito_user_pool_client_secret      = module.authentication.cognito_user_pool_client_secret
  dhcp_cluster_name                    = module.dhcp.ecs.cluster_name
  dhcp_service_name                    = module.dhcp.ecs.service_name
  dns_cluster_name                     = module.dns.ecs.cluster_name
  dns_service_name                     = module.dns.ecs.service_name
  dhcp_service_arn                     = module.dhcp.ecs.service_arn
  dhcp_http_api_load_balancer_arn      = module.dhcp.http_api_load_balancer_arn
  bind_config_bucket_name              = module.dns.bind_config_bucket_name
  bind_config_bucket_arn               = module.dns.bind_config_bucket_arn
  is_publicly_accessible               = local.publicly_accessible
  bind_config_bucket_key_arn           = module.dns.bind_config_bucket_key_arn
  dhcp_config_bucket_key_arn           = module.dhcp.dhcp_config_bucket_key_arn
  admin_local_development_domain_affix = var.admin_local_development_domain_affix
  pdns_ips                             = var.pdns_ips

  depends_on = [
    module.admin_vpc
  ]

  providers = {
    aws = aws.env
  }
}

module "authentication" {
  source                        = "./modules/authentication"
  azure_federation_metadata_url = var.azure_federation_metadata_url
  prefix                        = module.dhcp_label.id
  enable_authentication         = var.enable_authentication
  admin_url                     = module.admin.admin_url
  region                        = data.aws_region.current_region.id
  vpn_hosted_zone_domain        = var.vpn_hosted_zone_domain

  providers = {
    aws = aws.env
  }
}

module "dns" {
  source                              = "./modules/dns"
  prefix                              = module.dns_label.id
  subnets                             = module.servers_vpc.private_subnets
  tags                                = module.dns_label.tags
  load_balancer_private_ip_eu_west_2a = var.dns_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b = var.dns_load_balancer_private_ip_eu_west_2b
  vpc_id                              = module.servers_vpc.vpc_id
  vpc_cidr                            = local.dns_dhcp_vpc_cidr

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }
}

module "corsham_test_bastion" {
  source                     = "./modules/corsham_test"
  subnets                    = module.servers_vpc.public_subnets
  vpc_id                     = module.servers_vpc.vpc_id
  tags                       = module.dhcp_label.tags
  bastion_allowed_ingress_ip = var.bastion_allowed_ingress_ip
  bastion_allowed_egress_ip  = var.bastion_allowed_egress_ip
  transit_gateway_id         = var.dhcp_transit_gateway_id
  route_table_id             = module.servers_vpc.public_route_table_ids[0]
  corsham_vm_ip              = var.corsham_vm_ip

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }

  count = terraform.workspace == "production" && var.enable_corsham_test_bastion == true ? 1 : 0
}

module "dns_label" {
  source       = "./modules/label"
  service_name = "dns"
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
  tags   = module.dhcp_label.tags
  vpc_id = module.admin_vpc.vpc_id

  providers = {
    aws = aws.env
  }
}
