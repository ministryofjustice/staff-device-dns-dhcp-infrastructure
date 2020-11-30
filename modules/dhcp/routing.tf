resource "aws_nat_gateway" "eu_west_2a" {
  allocation_id = aws_eip.dns_eu_west_2a.id
  subnet_id     = var.subnets[0]

  tags = var.tags
}

resource "aws_nat_gateway" "eu_west_2b" {
  allocation_id = aws_eip.dns_eu_west_2b.id
  subnet_id     = var.subnets[1]

  tags = var.tags
}

resource "aws_eip" "dns_eu_west_2a" {
  vpc              = true
  public_ipv4_pool = "amazon"
}

resource "aws_eip" "dns_eu_west_2b" {
  vpc              = true
  public_ipv4_pool = "amazon"
}

resource "aws_route" "transit-gateway" {
  for_each = var.enable_dhcp_transit_gateway_attachment ? var.private_route_table_ids : []

  route_table_id            = each.value
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = var.dhcp_transit_gateway_id
}

resource "aws_route" "pdns-route-2a-pdns-1" {
  for_each = var.enable_dhcp_transit_gateway_attachment ? var.private_route_table_ids : []

  route_table_id            = each.value
  destination_cidr_block    = "${var.pdns_ips[0]}/32"
  nat_gateway_id            = aws_nat_gateway.eu_west_2a.id
}

resource "aws_route" "pdns-route-2a-pdns-2" {
  for_each = var.enable_dhcp_transit_gateway_attachment ? var.private_route_table_ids : []

  route_table_id            = each.value
  destination_cidr_block    = "${var.pdns_ips[1]}/32"
  nat_gateway_id            = aws_nat_gateway.eu_west_2a.id
}
