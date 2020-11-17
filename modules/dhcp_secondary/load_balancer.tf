resource "aws_lb" "load_balancer" {
  name               = var.prefix
  load_balancer_type = "network"
  internal           = true

  subnet_mapping {
    subnet_id            = var.subnets[0]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2a
  }

  subnet_mapping {
    subnet_id            = var.subnets[1]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2b
  }

  subnet_mapping {
    subnet_id            = var.subnets[2]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2c
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "target_group" {
  name                 = var.prefix
  protocol             = "TCP_UDP"
  vpc_id               = var.vpc_id
  port                 = var.container_port
  target_type          = "ip"
  deregistration_delay = 10

  depends_on = [aws_lb.load_balancer]
}

resource "aws_lb_target_group" "tcp_target_group" {
  name                 = "${var.prefix}-tcp"
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  port                 = "8000"
  target_type          = "ip"
  deregistration_delay = 10

  depends_on = [aws_lb.load_balancer]
}

resource "aws_lb_listener" "udp" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = var.container_port
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_listener" "tcp" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "8000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tcp_target_group.arn
  }
}
