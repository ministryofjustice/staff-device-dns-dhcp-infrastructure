resource "aws_route" "corsham" {
  route_table_id         = var.route_table_id
  destination_cidr_block = "${var.corsham_vm_ip}/32"
  transit_gateway_id     = var.transit_gateway_id
}
