resource "aws_acm_certificate" "admin_lb" {
  domain_name       = aws_route53_record.admin_lb.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate_validation" "admin_lb" {
  certificate_arn         = aws_acm_certificate.admin_lb.arn
  validation_record_fqdns = [aws_route53_record.admin_lb_verification.fqdn]
}
