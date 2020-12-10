resource "aws_lb" "load_balancer" {
  name               = "dhcp-${var.short_prefix}-standby"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = var.private_subnets[1]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2b
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "target_group" {
  name                 = "dhcp-${var.short_prefix}-standby"
  protocol             = "TCP_UDP"
  vpc_id               = var.vpc_id
  port                 = "67"
  target_type          = "ip"
  deregistration_delay = 300

  health_check {
    port     = 80
    protocol = "TCP"
  }

  depends_on = [aws_lb.load_balancer]
}

resource "aws_lb_listener" "udp" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "67"
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
