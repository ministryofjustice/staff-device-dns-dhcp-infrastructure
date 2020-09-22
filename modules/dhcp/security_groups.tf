resource "aws_security_group" "dhcp_server" {
  name        = "${var.prefix}-dhcp-container"
  description = "Allow the ECS agent to talk to the ECS endpoints"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 67
    to_port     = 67
    protocol    = "udp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_security_group_rule" "dhcp_container_db_out" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dhcp_server.id
  source_security_group_id = aws_security_group.dhcp_db_in.id
}

resource "aws_security_group" "dhcp_db_in" {
  name        = "${var.prefix}-dhcp-database-in"
  description = "Allow connections to the DB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.dhcp_server.id]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}
