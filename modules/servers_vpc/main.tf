resource "aws_security_group" "endpoints" {
  name   = "${var.prefix}-endpoints"
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = module.vpc.private_subnets_cidr_blocks
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.50.0"
  name    = var.prefix

  cidr                 = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ecr_dkr_endpoint              = true
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_api_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [aws_security_group.endpoints.id]

  enable_monitoring_endpoint              = true
  monitoring_endpoint_private_dns_enabled = true
  monitoring_endpoint_security_group_ids  = [aws_security_group.endpoints.id]

  enable_rds_endpoint              = true
  rds_endpoint_private_dns_enabled = true
  rds_endpoint_security_group_ids  = [aws_security_group.endpoints.id]

  enable_s3_endpoint = true

  enable_logs_endpoint              = true
  logs_endpoint_private_dns_enabled = true
  logs_endpoint_security_group_ids  = [aws_security_group.endpoints.id]

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
