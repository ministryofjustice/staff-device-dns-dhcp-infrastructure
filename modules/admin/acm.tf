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
  validation_record_fqdns = [for record in aws_route53_record.admin_lb_verification : record.fqdn]
}

resource "aws_acm_certificate" "admin_db" {
  domain_name       = aws_route53_record.admin_db.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate_validation" "admin_db" {
  certificate_arn         = aws_acm_certificate.admin_db.arn
  validation_record_fqdns = [for record in aws_route53_record.admin_db_verification : record.fqdn]
}
