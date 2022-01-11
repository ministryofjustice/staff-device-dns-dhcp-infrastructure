resource "aws_security_group" "endpoints" {
  name   = "${var.prefix}-endpoints"
  tags   = var.tags
  vpc_id = module.vpc.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.cidr_block]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  inbound_vpc_rules = [
    {
      "cidr_block" : var.cidr_block,
      "from_port" : 8000,
      "protocol" : "tcp",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 8000
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 8000,
      "protocol" : "tcp",
      "rule_action" : "deny",
      "rule_number" : 200,
      "to_port" : 8000
    },
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 300,
      "to_port" : 0
    }
  ]

  outbound_vpc_rules = [
    {
      "cidr_block" : "0.0.0.0/0",
      "from_port" : 0,
      "protocol" : "-1",
      "rule_action" : "allow",
      "rule_number" : 100,
      "to_port" : 0
    }
  ]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.70.0"
  name    = "${var.prefix}-dns"

  cidr                 = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  ecr_api_endpoint_private_dns_enabled = true
  ecr_api_endpoint_security_group_ids  = [aws_security_group.endpoints.id]
  ecr_dkr_endpoint_private_dns_enabled = true
  ecr_dkr_endpoint_security_group_ids  = [aws_security_group.endpoints.id]
  enable_ecr_api_endpoint              = true
  enable_ecr_dkr_endpoint              = true

  enable_monitoring_endpoint              = true
  monitoring_endpoint_private_dns_enabled = true
  monitoring_endpoint_security_group_ids  = [aws_security_group.endpoints.id]

  enable_rds_endpoint              = true
  rds_endpoint_private_dns_enabled = true
  rds_endpoint_security_group_ids  = [aws_security_group.endpoints.id]

  manage_default_network_acl    = true
  private_dedicated_network_acl = true
  private_inbound_acl_rules     = local.inbound_vpc_rules
  private_outbound_acl_rules    = local.outbound_vpc_rules
  public_dedicated_network_acl  = true
  public_inbound_acl_rules      = local.inbound_vpc_rules
  public_outbound_acl_rules     = local.outbound_vpc_rules

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

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
}
