resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true
  tags                = var.tags
  depends_on          = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "rds" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  service_name        = "com.amazonaws.${var.region}.rds"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true
  tags                = var.tags
  depends_on          = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id          = module.vpc.vpc_id
  route_table_ids = module.vpc.private_route_table_ids
  service_name    = "com.amazonaws.${var.region}.s3"
  tags            = var.tags
}

// endpoints required for session manager

resource "aws_vpc_endpoint" "ssm" {
  count               = var.ssm_session_manager_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true
  tags                = var.tags
  depends_on          = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  count               = var.ssm_session_manager_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true
  tags                = var.tags
  depends_on          = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "ec2messages" {
  count               = var.ssm_session_manager_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true
  tags                = var.tags
  depends_on          = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "kms" {
  count               = var.ssm_session_manager_endpoints ? 1 : 0
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.public_subnets
  service_name        = "com.amazonaws.${var.region}.kms"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true
  tags                = var.tags
  depends_on          = [aws_security_group.endpoints]
}
