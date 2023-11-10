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
