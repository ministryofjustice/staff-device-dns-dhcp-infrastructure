resource "aws_route53_resolver_endpoint" "internal_hosted_zone" {
  name      = "${var.prefix}-resolver-endpoint"
  direction = "INBOUND"

  security_group_ids = [
    aws_security_group.resolver_endpoint.id,
  ]

  ip_address {
    subnet_id = var.subnets[0]
    ip        = var.dns_route53_resolver_ip_eu_west_2a
  }

  ip_address {
    subnet_id = var.subnets[1]
    ip        = var.dns_route53_resolver_ip_eu_west_2b
  }

  tags = var.tags
}