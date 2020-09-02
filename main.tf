terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    bucket         = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-state"
    dynamodb_table = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-lock-table"
    region         = "eu-west-2"
  }
}

provider "template" {
  version = "~> 2.1"
}

provider "tls" {
  version = "> 2.1"
}

provider "aws" {
  version = "~> 3.4"
  alias   = "env"
  assume_role {
    role_arn = var.assume_role
  }
}

provider "local" {
  version = "~> 1.4"
}

module "dhcp_label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

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

module "vpc" {
  source              = "./modules/vpc"
  prefix              = module.dhcp_label.id
  region              = data.aws_region.current_region.id
  cidr_block          = "10.180.80.0/22"
  cidr_block_new_bits = 2

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
  subnets                                = module.vpc.public_subnets
  tags                                   = module.dhcp_label.tags
  vpc_id                                 = module.vpc.vpc_id
  dhcp_db_password                       = var.dhcp_db_password
  dhcp_db_username                       = var.dhcp_db_username
  public_subnet_cidr_blocks              = module.vpc.public_subnet_cidr_blocks
  env                                    = var.env
  dhcp_transit_gateway_id                = var.dhcp_transit_gateway_id
  enable_dhcp_transit_gateway_attachment = var.enable_dhcp_transit_gateway_attachment
  transit_gateway_route_table_id         = var.transit_gateway_route_table_id
  load_balancer_private_ip_eu_west_2a    = var.load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b    = var.load_balancer_private_ip_eu_west_2b
  load_balancer_private_ip_eu_west_2c    = var.load_balancer_private_ip_eu_west_2c
  critical_notifications_arn             = module.alarms.critical_notifications_arn
  vpn_hosted_zone_id                     = var.vpn_hosted_zone_id
  vpn_hosted_zone_domain                 = var.vpn_hosted_zone_domain
  short_prefix                           = module.dhcp_label.stage # avoid 32 char limit on certain resources
  region                                 = data.aws_region.current_region.id

  providers = {
    aws = aws.env
  }
}

module "admin" {
  source                           = "./modules/admin"
  prefix                           = "${module.dhcp_label.id}-admin"
  short_prefix                     = module.dhcp_label.stage # avoid 32 char limit on certain resources
  tags                             = module.dhcp_label.tags
  vpc_id                           = module.admin_vpc.vpc_id
  admin_db_password                = var.admin_db_password
  admin_db_username                = var.admin_db_username
  subnet_ids                       = module.admin_vpc.public_subnets
  sentry_dsn                       = "tbc"
  secret_key_base                  = "tbc"
  kea_config_bucket_arn            = module.dhcp.kea_config_bucket_arn
  kea_config_bucket_name           = module.dhcp.kea_config_bucket_name
  region                           = data.aws_region.current_region.id
  vpn_hosted_zone_id               = var.vpn_hosted_zone_id
  vpn_hosted_zone_domain           = var.vpn_hosted_zone_domain
  admin_db_backup_retention_period = var.admin_db_backup_retention_period
  cognito_user_pool_id             = module.cognito.cognito_user_pool_id
  cognito_user_pool_domain         = module.cognito.cognito_user_pool_domain
  cognito_user_pool_client_id      = module.cognito.cognito_user_pool_client_id
  cognito_user_pool_client_secret  = module.cognito.cognito_user_pool_client_secret

  providers = {
    aws = aws.env
  }
}

module "cognito" {
  source                = "./modules/authentication"
  meta_data_url         = var.meta_data_url
  prefix                = module.dhcp_label.id
  enable_authentication = var.enable_authentication
  admin_url             = module.admin.admin_url

  providers = {
    aws = aws.env
  }
}

module "alarms" {
  source                           = "./modules/alarms"
  dhcp_cluster_name                = module.dhcp.aws_ecs_cluster_name
  prefix                           = module.dhcp_label.id
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
  source = "./modules/dns"
  prefix = module.dns_label.id
  providers = {
    aws = aws.env
  }
}

module "dns_label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

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
