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
  version = "~> 3.6"
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
  source  = "cloudposse/label/null"
  version = "0.19.2"

  namespace = "staff-device"
  stage     = terraform.workspace
  name      = "dhcp"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "dns-dhcp",
    "is-production" = tostring(var.is_production),
    "owner"         = var.owner_email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-dns-dhcp-infrastructure"
  }
}

data "aws_region" "current_region" {}
data "aws_caller_identity" "shared_services_account" {}

locals {
  dns_dhcp_vpc_cidr = "10.180.80.0/22"
}

module "servers_vpc" {
  source                           = "./modules/servers_vpc"
  prefix                           = module.dhcp_label.id
  region                           = data.aws_region.current_region.id
  cidr_block                       = "10.180.80.0/22"
  cidr_block_new_bits              = 2
  enable_nat_gateway               = true
  rds_endpoint_private_dns_enabled = true

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

module "dhcp" {
  source                                 = "./modules/dhcp"
  prefix                                 = module.dhcp_label.id
  subnets                                = module.servers_vpc.private_subnets
  tags                                   = module.dhcp_label.tags
  vpc_id                                 = module.servers_vpc.vpc_id
  dhcp_db_password                       = var.dhcp_db_password
  dhcp_db_username                       = var.dhcp_db_username
  env                                    = var.env
  dhcp_transit_gateway_id                = var.dhcp_transit_gateway_id
  enable_dhcp_transit_gateway_attachment = var.enable_dhcp_transit_gateway_attachment
  transit_gateway_route_table_id         = var.transit_gateway_route_table_id
  load_balancer_private_ip_eu_west_2a    = var.dhcp_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b    = var.dhcp_load_balancer_private_ip_eu_west_2b
  critical_notifications_arn             = module.alarms.critical_notifications_arn
  vpn_hosted_zone_id                     = var.vpn_hosted_zone_id
  vpn_hosted_zone_domain                 = var.vpn_hosted_zone_domain
  short_prefix                           = module.dhcp_label.stage # avoid 32 char limit on certain resources
  region                                 = data.aws_region.current_region.id
  is_publicly_accessible                 = local.publicly_accessible
  vpc_cidr                               = local.dns_dhcp_vpc_cidr
  admin_local_development_domain_affix   = var.admin_local_development_domain_affix
  dhcp_egress_transit_gateway_routes     = var.dhcp_egress_transit_gateway_routes
  private_route_table_ids                = module.servers_vpc.private_route_table_ids

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
  dhcp_db_username                     = var.dhcp_db_username
  dhcp_db_password                     = var.dhcp_db_password
  dhcp_db_name                         = module.dhcp.db_name
  dhcp_db_host                         = module.dhcp.db_host
  dhcp_db_port                         = module.dhcp.db_port
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

module "alarms" {
  source                           = "./modules/alarms"
  dhcp_cluster_name                = module.dhcp.ecs.cluster_name
  prefix                           = module.alarms_label.id
  enable_critical_notifications    = var.enable_critical_notifications
  critical_notification_recipients = var.critical_notification_recipients
  rds_identifier                   = module.dhcp.rds_identifier
  load_balancer                    = module.dhcp.load_balancer
  topic_name                       = "critical-notifications"
  admin_db_identifier              = module.admin.admin_db_identifier
  providers = {
    aws = aws.env
  }
}

module "dns" {
  source                              = "./modules/dns"
  prefix                              = module.dns_label.id
  subnets                             = module.servers_vpc.private_subnets
  tags                                = module.dns_label.tags
  critical_notifications_arn          = module.alarms.critical_notifications_arn
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

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }

  count = terraform.workspace == "production" && var.enable_corsham_test_bastion == true ? 1 : 0
}

module "bsi_test_vm_admin_vpc" {
  source                          = "./modules/bsi_pentest_vm"
  subnets                         = module.admin_vpc.public_subnets
  vpc_id                          = module.admin_vpc.vpc_id
  pentesting_vm_ami_id            = var.pentesting_vm_ami_id
  pentesting_vm_ami_ingress_cidrs = var.pentesting_vm_ami_ingress_cidrs

  depends_on = [
    module.admin_vpc
  ]

  providers = {
    aws = aws.env
  }

  count = terraform.workspace == "pre-production" ? 1 : 0
}

module "bsi_test_vm_servers_vpc" {
  source                          = "./modules/bsi_pentest_vm"
  subnets                         = module.servers_vpc.public_subnets
  vpc_id                          = module.servers_vpc.vpc_id
  pentesting_vm_ami_id            = var.pentesting_vm_ami_id
  pentesting_vm_ami_ingress_cidrs = var.pentesting_vm_ami_ingress_cidrs

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }

  count = terraform.workspace == "pre-production" ? 1 : 0
}

module "dns_label" {
  source  = "cloudposse/label/null"
  version = "0.19.2"

  namespace = "staff-device"
  stage     = terraform.workspace
  name      = "dns"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "dns-dhcp",
    "is-production" = tostring(var.is_production),
    "owner"         = var.owner_email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-dns-dhcp-infrastructure"
  }
}

module "alarms_label" {
  source  = "cloudposse/label/null"
  version = "0.19.2"

  namespace = "staff-device"
  stage     = terraform.workspace
  name      = "alarms"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "dns-dhcp",
    "is-production" = tostring(var.is_production),
    "owner"         = var.owner_email

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-dns-dhcp-infrastructure"
  }
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
