module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"
  name    = var.prefix

  cidr               = var.cidr_block
  enable_nat_gateway = true
  create_database_subnet_group           = true
  create_database_subnet_route_table     = true
  create_database_internet_gateway_route = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  database_subnets = [
    cidrsubnet(var.cidr_block, 8, 4),
    cidrsubnet(var.cidr_block, 8, 5)
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, 8, 1),
    cidrsubnet(var.cidr_block, 8, 2),
    cidrsubnet(var.cidr_block, 8, 3)
  ]
}
