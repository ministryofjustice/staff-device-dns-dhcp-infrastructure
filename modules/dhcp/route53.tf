resource "aws_route53_record" "dhcp_db" {
  zone_id =  var.vpn_hosted_zone_id
  ttl = 60
  type    = "CNAME"

  name    = "staff-device-${var.short_prefix}-dhcp-db.${var.vpn_hosted_zone_domain}"
  records = [aws_db_instance.dhcp_server_db.address]
}
