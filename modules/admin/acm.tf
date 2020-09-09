resource "aws_acm_certificate" "admin_lb" {
  domain_name       = local.lb_verification_record_fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

locals {
  lb_verification_record_fqdn = var.enable_custom_domain_name ? aws_route53_record.admin_lb[0].fqdn : aws_lb.admin_alb.dns_name
}

resource "aws_acm_certificate_validation" "admin_lb" {
  certificate_arn         = aws_acm_certificate.admin_lb.arn
  validation_record_fqdns = [local.lb_verification_record_fqdn]
}
