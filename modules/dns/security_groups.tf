resource "aws_security_group" "dns_server" {
  name        = "${var.prefix}-dns-container"
  description = "Allow the ECS agent to talk to the ECS endpoints"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "dns_container_web_out" {
  description       = "Allow SSL outbound connections from the container"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.dns_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dns_container_udp_in" {
  description       = "Allow inbound traffic to the BIND server"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.dns_server.id
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "dns_container_udp_out" {
  description       = "Allow outbound traffic from the BIND server"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.dns_server.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "dns_container_healthcheck_in" {
  description       = "Allow health checks from the Load Balancer"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.dns_server.id
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group" "resolver_endpoint" {
  name        = "${var.prefix}-resolver-endpoint"
  description = "Allow the bind9 to talk to resolver endpoints"
  vpc_id      = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "resolver_endpoint_dns_udp_in" {
  description       = "Allow incoming dns udp traffic to resolver endpoint"
  type              = "ingress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.resolver_endpoint.id
  cidr_blocks       = [var.vpc_cidr]
}

resource "aws_security_group_rule" "resolver_endpoint_dns_udp_out" {
  description       = "Allow outgoing dns udp traffic from resolver endpoint"
  type              = "egress"
  from_port         = 53
  to_port           = 53
  protocol          = "udp"
  security_group_id = aws_security_group.resolver_endpoint.id
  cidr_blocks       = [var.vpc_cidr]
}
