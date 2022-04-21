terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.75.0"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  name    = var.prefix

  cidr                 = var.cidr_block
  enable_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = [
    "${var.region}a",
    "${var.region}b"
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 1),
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 2)
  ]

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
}
