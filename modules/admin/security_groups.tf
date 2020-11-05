resource "aws_security_group" "admin_alb" {
  name        = "${var.prefix}-load-balancer"
  description = "Allow Traffic to the Admin Portal"
  vpc_id      = var.vpc_id

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "admin_alb_in_from_web" {
  description       = "Allow HTTPS traffic to the admin load balancer from the web"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.admin_alb.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "admin_alb_out" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.admin_alb.id
  source_security_group_id = aws_security_group.admin_ecs.id
}

resource "aws_security_group" "admin_db" {
  name        = "${var.prefix}-database"
  description = "Allow connections to the DB"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_security_group_rule" "admin_db_in_from_ecs" {
  description              = "Allow access to admin database from app containers"
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.admin_db.id
  source_security_group_id = aws_security_group.admin_ecs.id
}

resource "aws_security_group" "admin_ecs" {
  name        = "${var.prefix}-container"
  description = "Allow traffic to and from Admin ECS"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
resource "aws_security_group_rule" "admin_ecs_in" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.admin_ecs.id
  source_security_group_id = aws_security_group.admin_alb.id
}

resource "aws_security_group_rule" "admin_ecs_out_to_db" {
  description              = "Allow access from admin app containers to admin database"
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.admin_ecs.id
  source_security_group_id = aws_security_group.admin_db.id
}

resource "aws_security_group_rule" "admin_ecs_out_to_web" {
  description       = "Allow HTTPS access from admin app containers to the web"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.admin_ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "admin_ecs_out_to_dhcp_api" {
  description       = "Allow HTTP access from admin app containers to DHCP API via a VPC endpoint"
  type              = "egress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  security_group_id = aws_security_group.admin_ecs.id
  source_security_group_id = aws_security_group.dhcp_api_vpc_endpoint.id
}

resource "aws_security_group" "dhcp_api_vpc_endpoint" {
  name        = "${var.prefix}-dhcp-api-vpc-endpoint"
  description = "Admin VPC endpoint for consuming DHCP HTTP API"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "dhcp_api_vpc_endpoint_in_from_admin_ecs" {
  description              = "Allow HTTP access to DHCP API via a VPC endpoint from admin app containers"
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dhcp_api_vpc_endpoint.id
  source_security_group_id = aws_security_group.admin_ecs.id
}
