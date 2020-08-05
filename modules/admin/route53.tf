resource "aws_route53_record" "admin_lb" {
  zone_id        = var.vpn_hosted_zone_id
  name           = "${var.prefix}.dev.vpn.justice.gov.uk"
  type           = "A"
  set_identifier = var.region

  alias {
    name                   = aws_lb.admin_alb.dns_name
    zone_id                = aws_lb.admin_alb.zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.region
  }
}

resource "aws_route53_record" "admin_lb_verification" {
  name    = aws_acm_certificate.admin_lb.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.admin_lb.domain_validation_options.0.resource_record_type
  zone_id = var.vpn_hosted_zone_id
  records = [aws_acm_certificate.admin_lb.domain_validation_options.0.resource_record_value]
  ttl     = 60
}
