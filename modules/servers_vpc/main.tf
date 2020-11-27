module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.50.0"
  name    = var.prefix

  cidr                 = var.cidr_block
  enable_nat_gateway   = var.enable_nat_gateway
  enable_dns_hostnames = true
  enable_dns_support   = true

  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  enable_flow_log                      = true

  rds_endpoint_private_dns_enabled     = var.rds_endpoint_private_dns_enabled
  rds_endpoint_security_group_ids      = []
  enable_s3_endpoint                   = var.enable_s3_endpoint

  azs = [
    "${var.region}a",
    "${var.region}b"
  ]

  private_subnets = [
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 0),
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 1)
  ]

  public_subnets = [
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 2),
    cidrsubnet(var.cidr_block, var.cidr_block_new_bits, 3)
  ]
}
