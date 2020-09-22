module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.50.0"
  name    = var.prefix

  cidr                    = var.cidr_block
  enable_nat_gateway      = true
  enable_dns_hostnames    = true
  enable_dns_support      = true

  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 1),
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 2),
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 3)
  ]
}
