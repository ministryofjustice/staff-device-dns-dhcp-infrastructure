resource "aws_route" "egress_routes" {
  for_each = var.public_route_table_ids

  route_table_id         = each.value
  destination_cidr_block = var.dhcp_egress_transit_gateway_routes[0]
  transit_gateway_id     = var.dhcp_transit_gateway_id
}
