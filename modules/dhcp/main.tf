resource "aws_lb" "load_balancer" {
  name               = var.prefix
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = var.subnets[0]
    allocation_id = aws_eip.public_ip.id
  }

  enable_deletion_protection = false

  tags = var.tags
}

resource "aws_lb_target_group" "target_group" {
  name = var.prefix
  port = 67
  protocol = "UDP"
  vpc_id = var.vpc_id

  health_check {
    protocol = "TCP"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.dhcp_server.id
  port             = 67
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
