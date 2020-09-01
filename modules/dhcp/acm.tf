resource "aws_acm_certificate" "dhcp_server_db" {
  domain_name       = aws_route53_record.dhcp_server_db.fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

# resource "aws_acm_certificate_validation" "dhcp_server_db" {
#   certificate_arn         = aws_acm_certificate.dhcp_server_db.arn
#   validation_record_fqdns = [for record in aws_route53_record.kea_lease_db_verification : record.fqdn]
# }
