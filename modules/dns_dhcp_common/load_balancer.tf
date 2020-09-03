resource "aws_lb" "load_balancer" {
  name               = var.prefix
  load_balancer_type = "network"
  internal = true

  subnet_mapping {
    subnet_id     = var.subnets[0]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2a
  }

  subnet_mapping {
    subnet_id     = var.subnets[1]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2b
  }

  subnet_mapping {
    subnet_id     = var.subnets[2]
    private_ipv4_address = var.load_balancer_private_ip_eu_west_2c
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "target_group" {
  name = var.prefix
  port = var.container_port
  protocol = "UDP"
  vpc_id = var.vpc_id

  health_check {
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
