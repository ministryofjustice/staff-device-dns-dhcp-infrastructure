resource "aws_lb" "admin_alb" {
  name     = "${var.short_prefix}-lb"
  internal = false
  subnets  = var.subnet_ids

  security_groups = [
    aws_security_group.admin_alb_in.id,
    aws_security_group.admin_alb_out.id
  ]

  load_balancer_type = "application"

  tags = var.tags
}

resource "aws_alb_listener" "alb_listener" {
  depends_on        = [aws_acm_certificate.admin_lb]
  load_balancer_arn = aws_lb.admin_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   =  aws_acm_certificate.admin_lb.arn

  default_action {
    target_group_arn = aws_alb_target_group.admin_tg.arn
    type             = "forward"
  }
}
