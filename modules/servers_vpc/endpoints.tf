resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = var.tags

  depends_on = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = var.tags

  depends_on = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = var.tags

  depends_on = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "rds" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.${var.region}.rds"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = var.tags

  depends_on = [aws_security_group.endpoints]
}

resource "aws_vpc_endpoint" "monitoring" {
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnets
  service_name        = "com.amazonaws.${var.region}.monitoring"
  vpc_endpoint_type   = "Interface"
  security_group_ids  = [aws_security_group.endpoints.id]
  private_dns_enabled = true

  tags = var.tags

  depends_on = [aws_security_group.endpoints]
}


resource "aws_vpc_endpoint" "s3" {
  vpc_id          = module.vpc.vpc_id
  route_table_ids = module.vpc.private_route_table_ids
  service_name    = "com.amazonaws.${var.region}.s3"

  tags = var.tags
}