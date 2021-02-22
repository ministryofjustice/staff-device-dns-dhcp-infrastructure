resource "aws_security_group" "heartbeat_instance" {
  name_prefix = var.prefix

  description = "Allow communication with the primary DHCP server"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_security_group_rule" "heartbeat_dhcp_out" {
  description       = "Allow dhcp requests out"
  type              = "egress"
  from_port         = 67
  to_port           = 67
  protocol          = "udp"
  security_group_id = aws_security_group.heartbeat_instance.id
  cidr_blocks       = ["${var.dhcp_ip}/32"]
}

resource "aws_security_group_rule" "heartbeat_dhcp_in" {
  description       = "Allow DHCP requests in"
  type              = "ingress"
  from_port         = 67
  to_port           = 67
  protocol          = "udp"
  security_group_id = aws_security_group.heartbeat_instance.id
  cidr_blocks       = ["${var.dhcp_ip}/32"]
}

resource "aws_security_group_rule" "heartbeat_http_out" {
  description       = "Allow TCP 80 out"
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.heartbeat_instance.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "heartbeat_dhcp_ssl_out" {
  description       = "Allow instance to write to Cloudwatch"
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.heartbeat_instance.id
  cidr_blocks       = ["0.0.0.0/0"]
}
