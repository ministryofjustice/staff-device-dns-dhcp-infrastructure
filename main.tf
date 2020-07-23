terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    bucket         = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-state"
    dynamodb_table = "pttp-ci-infrastructure-dns-dhcp-client-core-tf-lock-table"
    region         = "eu-west-2"
  }
}

provider "tls" {
  version = "> 2.1"
}

provider "aws" {
  version = "~> 2.68"
  alias   = "env"
  assume_role {
    role_arn = var.assume_role
  }
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
  source     = "./modules/vpc"
  prefix     = module.dhcp_label.id
  region     = data.aws_region.current_region.id
  cidr_block = "10.0.0.0/16"

  providers = {
    aws = aws.env
  }
}

module "dhcp" {
  source  = "./modules/dhcp"
  prefix  = module.dhcp_label.id
  subnets = module.vpc.public_subnets
  tags    = module.dhcp_label.tags
  vpc_id  = module.vpc.vpc_id

  providers = {
    aws = aws.env
  }
}

module "cognito" {
  source = "./modules/authentication"

   providers = {
    aws = aws.env
  }
}
