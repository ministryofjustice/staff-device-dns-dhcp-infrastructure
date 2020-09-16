resource "aws_route53_record" "admin_alb" {
  zone_id        = var.vpn_hosted_zone_id
  name           = "staff-device-${var.short_prefix}-admin.${var.vpn_hosted_zone_domain}"
  type           = "A"
  set_identifier = var.region

  alias {
    name                   = aws_lb.admin_alb.dns_name
    zone_id                = aws_lb.admin_alb.zone_id
    evaluate_target_health = true
  }

  weighted_routing_policy {
    weight = "100"
  }
}

resource "aws_route53_record" "admin_alb_verification" {
  zone_id = var.vpn_hosted_zone_id
  ttl     = 60

  name    = tolist(aws_acm_certificate.admin_alb.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.admin_alb.domain_validation_options)[0].resource_record_value]
  type    = tolist(aws_acm_certificate.admin_alb.domain_validation_options)[0].resource_record_type
}

resource "aws_route53_record" "admin_db" {
  zone_id = var.vpn_hosted_zone_id
  ttl     = 60
  type    = "CNAME"

  name    = "staff-device-${var.short_prefix}-admin-db.${var.vpn_hosted_zone_domain}"
  records = [aws_db_instance.admin_db.address]
}
