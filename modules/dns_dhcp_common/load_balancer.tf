resource "aws_lb" "load_balancer" {
  name               = var.prefix
  load_balancer_type = "network"
  internal           = true

  dynamic "subnet_mapping" {
    for_each = [for c in var.load_balancer_config : {
      subnet_id            = c.subnet_id
      private_ipv4_address = c.private_ipv4_address
    }]

    content {
      subnet_id            = subnet_mapping.value.subnet_id
      private_ipv4_address = subnet_mapping.value.private_ipv4_address
    }
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "target_group" {
  name                 = "${var.prefix}-ha-primary"
  protocol             = "TCP_UDP"
  vpc_id               = var.vpc_id
  port                 = var.container_port
  target_type          = "ip"
  deregistration_delay = 300

  health_check {
    port     = 80
    protocol = "TCP"
  }

  depends_on = [aws_lb.load_balancer]
}

resource "aws_lb_target_group" "target_group_ha" {
  name                 = "${var.prefix}-ha-api"
  protocol             = "TCP"
  vpc_id               = var.vpc_id
  port                 = 8000
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
  port              = var.container_port
  protocol          = "UDP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}

resource "aws_lb_listener" "ha" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = 8000
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group_ha.arn
  }
}
