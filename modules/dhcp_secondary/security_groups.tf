resource "aws_security_group" "dhcp_server" {
  name        = "${var.prefix}-dhcp-container"
  description = "Allow the ECS agent to talk to the ECS endpoints"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "dhcp_container_healthcheck_in" {
  description       = "Allow health checks from the Load Balancer"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.dhcp_server.id
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "dhcp_container_kea_api_in" {
  description       = "Allow HTTP access to the kea api from the vpc endpoint"
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  security_group_id = aws_security_group.dhcp_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dhcp_container_kea_api_out" {
  description       = "Allow HTTP access to the kea api from the vpc endpoint"
  type              = "egress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  security_group_id = aws_security_group.dhcp_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "dhcp_container_udp_in" {
  description       = "Allow inbound traffic to the KEA server"
  type              = "ingress"
  from_port         = 67
  to_port           = 67
  protocol          = "udp"
  security_group_id = aws_security_group.dhcp_server.id
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "dhcp_container_udp_out" {
  description       = "Allow outbound traffic to DHCP client from the Kea server"
  type              = "egress"
  from_port         = 68
  to_port           = 68
  protocol          = "udp"
  security_group_id = aws_security_group.dhcp_server.id
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "dhcp_container_web_out" {
  description       = "Allow SSL outbound connections from the container"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.dhcp_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "dhcp_container_db_out" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.dhcp_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}
