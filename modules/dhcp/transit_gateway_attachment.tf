resource "aws_ec2_transit_gateway_vpc_attachment" "dhcp_transit_gateway_attachment" {
  count = var.enable_dhcp_transit_gateway_attachment

  subnet_ids         = var.subnets
  transit_gateway_id = var.dhcp_transit_gateway_id
  vpc_id             = var.vpc_id
}
