resource "aws_route53_record" "kea_lease_db" {
  zone_id        = var.vpn_hosted_zone_id
  name           = "staff-device-dhcp-lease-db-${var.short_prefix}.${var.vpn_hosted_zone_domain}"
  type           = "A"
  set_identifier = var.region

  alias {
    name                   = aws_db_instance.dhcp_server_db.address
    zone_id                = aws_db_instance.dhcp_server_db.hosted_zone_id
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = var.region
  }
}

# resource "aws_route53_record" "kea_lease_db_verification" {
#   zone_id = var.vpn_hosted_zone_id
#   ttl     = 60

#   for_each = {
#     for dvo in aws_acm_certificate.dhcp_server_db.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       record = dvo.resource_record_value
#       type   = dvo.resource_record_type
#     }
#   }

#   name    = each.value.name
#   records = [each.value.record]
#   type    = each.value.type
# }
