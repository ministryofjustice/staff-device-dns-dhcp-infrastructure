resource "aws_acm_certificate" "admin_alb" {
  domain_name       = "dhcp-dns-admin.${var.domain_affix}.${var.vpn_hosted_zone_domain}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate_validation" "admin_alb" {
  certificate_arn         = aws_acm_certificate.admin_alb.arn
  validation_record_fqdns = [for record in aws_route53_record.admin_alb : record.fqdn]
}

resource "aws_route53_record" "admin_alb" {
  for_each = {
    for dvo in aws_acm_certificate.admin_alb.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name            = each.value.name
  records         = [each.value.record]
  ttl             = 3600
  type            = each.value.type
  zone_id         = var.vpn_hosted_zone_id
}

resource "aws_route53_record" "admin_db" {
  zone_id = var.vpn_hosted_zone_id
  ttl     = 3600
  type    = "CNAME"

  name    = "dhcp-dns-admin-db.${var.domain_affix}.${var.vpn_hosted_zone_domain}"
  records = [aws_db_instance.admin_db.address]
}
