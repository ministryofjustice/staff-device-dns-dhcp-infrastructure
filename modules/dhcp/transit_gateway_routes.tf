resource "aws_route" "transit-gateway" {
  for_each = var.enable_dhcp_transit_gateway_attachment ? var.private_route_table_ids : []

  route_table_id            = each.value
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id        = var.dhcp_transit_gateway_id
}
