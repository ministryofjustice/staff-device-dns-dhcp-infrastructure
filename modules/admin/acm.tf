resource "aws_acm_certificate" "admin_alb" {
  domain_name       = aws_route53_record.admin_alb.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate_validation" "admin_alb" {
  certificate_arn         = aws_acm_certificate.admin_alb.arn
  validation_record_fqdns = aws_route53_record.admin_alb_verification.*.fqdn
}
