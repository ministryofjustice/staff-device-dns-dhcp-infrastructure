resource "aws_lb" "http_api_load_balancer" {
  name               = "${var.short_prefix}-dhcp-api"
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = var.private_subnets[0]
    private_ipv4_address = var.dhcp_api_load_balancer_private_ip_eu_west_2a
  }

  subnet_mapping {
    subnet_id            = var.private_subnets[1]
    private_ipv4_address = var.dhcp_api_load_balancer_private_ip_eu_west_2b
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "http_api_target_group" {
  name                 = "${var.short_prefix}-dhcp-api"
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  port                 = "8000"
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    port     = 80
    protocol = "TCP"
  }

  depends_on = [aws_lb.http_api_load_balancer]
}

resource "aws_lb_listener" "http_api_tcp" {
  load_balancer_arn = aws_lb.http_api_load_balancer.arn
  port              = "8000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http_api_target_group.arn
  }
}
