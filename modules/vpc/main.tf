module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"
  name    = var.prefix

  cidr               = var.cidr_block
  enable_nat_gateway = true
<<<<<<< HEAD
=======
  enable_dns_hostnames = true
  enable_dns_support   = true
>>>>>>> main

  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, 8, 1),
    cidrsubnet(var.cidr_block, 8, 2),
    cidrsubnet(var.cidr_block, 8, 3)
  ]
}
