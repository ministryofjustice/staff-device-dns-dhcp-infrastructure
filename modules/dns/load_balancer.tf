resource "aws_lb" "load_balancer" {
  name                             = var.prefix
  load_balancer_type               = "network"
  internal                         = true
  enable_cross_zone_load_balancing = true

  subnet_mapping {
    subnet_id            = var.subnets[0]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2a
  }

  subnet_mapping {
    subnet_id            = var.subnets[1]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2b
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_listener" "udp" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "53"
  protocol          = "TCP_UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_target_group" "target_group" {
  name                 = var.prefix
  protocol             = "TCP_UDP"
  vpc_id               = var.vpc_id
  port                 = "53"
  target_type          = "ip"
  deregistration_delay = 300

  # health check changed to TCP port 53 due to P1 - this allows continers to come up healthy.
  health_check {
    port                = 53
    protocol            = "TCP"
    unhealthy_threshold = 10
    interval            = 300
  }

  tags = var.tags

  depends_on = [aws_lb.load_balancer]
}
