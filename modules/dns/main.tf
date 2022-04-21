terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.75.0"
    }
  }
}

module "dns_dhcp_common" {
  source = "../dns_dhcp_common"
  prefix = var.prefix
  vpc_id = var.vpc_id
  tags   = var.tags
}
