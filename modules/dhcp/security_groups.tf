resource "aws_security_group" "dhcp_server" {
  name        = "${var.prefix}-dhcp-server"
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

  tags = var.tags
}

resource "aws_security_group" "dhcp_db_in" {
  name        = "${var.prefix}-dhcp-db-in"
  description = "Allow connections to the DB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.dhcp_server.id]
  }

  tags = var.tags
}
