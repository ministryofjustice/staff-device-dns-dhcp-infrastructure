terraform {
  backend "s3" {
    bucket         = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-state"
    dynamodb_table = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-lock-table"
    region         = "eu-west-2"
  }
}

data "aws_caller_identity" "current" {}

provider "mysql" {
  endpoint = module.dhcp.rds.endpoint
  username = data.aws_ssm_parameter.dhcp_db_username.value
  password = data.aws_ssm_parameter.dhcp_db_password.value
}

provider "aws" {
  alias = "env"
  assume_role {
    role_arn = var.assume_role
  }
}

data "aws_region" "current_region" {}
data "aws_caller_identity" "shared_services_account" {}

module "dns_label" {
  source       = "./modules/label"
  service_name = "dns"
  owner_email  = var.owner_email
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

module "kinesis_firehose_xsiam" {
  source                                = "./modules/kinesis_firehose_xsiam"
  http_endpoint                         = jsondecode(data.aws_secretsmanager_secret_version.xsiam_secrets_version.secret_string)["http_endpoint"]
  access_key                            = jsondecode(data.aws_secretsmanager_secret_version.xsiam_secrets_version.secret_string)["access_key"]
  prefix                                = "${module.dhcp_label.id}-xsiam"
  tags                                  = module.dhcp_label.tags
  cloudwatch_log_group_for_subscription = module.dhcp.cloudwatch.server_log_group_name

  providers = {
    aws = aws.env
  }
}

