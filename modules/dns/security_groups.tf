resource "aws_security_group" "dns_server" {
  name        = "${var.prefix}-dns-container"
  description = "Allow the ECS agent to talk to the ECS endpoints"
  vpc_id      = var.vpc_id

  tags = var.tags
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

resource "aws_security_group_rule" "dns_container_healthcheck_in" {
  description       = "Allow health checks from the Load Balancer"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.dns_server.id
  cidr_blocks       = [var.vpc_cidr]
}
