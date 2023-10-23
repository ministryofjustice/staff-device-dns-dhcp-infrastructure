resource "aws_nat_gateway" "eu_west_2a" {
  allocation_id = aws_eip.dns_eu_west_2a.id
  subnet_id     = module.vpc.public_subnets[0]

  tags = var.tags

  depends_on = [
    module.vpc
  ]
}

resource "aws_nat_gateway" "eu_west_2b" {
  allocation_id = aws_eip.dns_eu_west_2b.id
  subnet_id     = module.vpc.public_subnets[1]

  tags = var.tags

  depends_on = [
    module.vpc
  ]
}

resource "aws_eip" "dns_eu_west_2a" {
  vpc              = true
  public_ipv4_pool = var.byoip_pool_id

  depends_on = [
    module.vpc
  ]
}

resource "aws_eip" "dns_eu_west_2b" {
  vpc              = true
  public_ipv4_pool = var.byoip_pool_id

  depends_on = [
    module.vpc
  ]
}

resource "aws_route" "transit-gateway" {
  for_each = var.enable_dhcp_transit_gateway_attachment ? toset(module.vpc.private_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = "0.0.0.0/0"
  transit_gateway_id     = var.dhcp_transit_gateway_id

  depends_on = [
    module.vpc
  ]
}

data "aws_route_tables" "availability_zone_2a" {
  vpc_id = module.vpc.vpc_id

  filter {
    name   = "tag:Name"
    values = ["staff-device-${terraform.workspace}-dhcp-dns-private-eu-west-2a"]
  }
}

data "aws_route_tables" "availability_zone_2b" {
  vpc_id = module.vpc.vpc_id

  filter {
    name   = "tag:Name"
    values = ["staff-device-${terraform.workspace}-dhcp-dns-private-eu-west-2b"]
  }
}

resource "aws_route" "pdns-route-2a-pdns-1" {
  for_each = toset(var.pdns_ips)

  route_table_id         = var.enable_dhcp_transit_gateway_attachment ? data.aws_route_tables.availability_zone_2a.ids[0] : null
  destination_cidr_block = "${each.value}/32"
  nat_gateway_id         = aws_nat_gateway.eu_west_2a.id

  timeouts {
    create = "5m"
  }

  depends_on = [
    module.vpc
  ]
}

resource "aws_route" "pdns-route-2b-pdns-1" {
  for_each = toset(var.pdns_ips)

  route_table_id         = var.enable_dhcp_transit_gateway_attachment ? data.aws_route_tables.availability_zone_2b.ids[0] : null
  destination_cidr_block = "${each.value}/32"
  nat_gateway_id         = aws_nat_gateway.eu_west_2b.id

  timeouts {
    create = "5m"
  }

  depends_on = [
    module.vpc
  ]
}

resource "aws_route" "model-office-testing-route" {
  for_each = var.enable_dhcp_transit_gateway_attachment ? toset(module.vpc.public_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = "${var.model_office_vm_ip}/32"
  transit_gateway_id     = var.dhcp_transit_gateway_id

  timeouts {
    create = "5m"
  }

  depends_on = [
    module.vpc
  ]
}

resource "aws_route" "corsham-testing-route" {
  for_each = var.enable_dhcp_transit_gateway_attachment ? toset(module.vpc.public_route_table_ids) : []

  route_table_id         = each.value
  destination_cidr_block = "${var.corsham_vm_ip}/32"
  transit_gateway_id     = var.dhcp_transit_gateway_id

  timeouts {
    create = "5m"
  }

  depends_on = [
    module.vpc
  ]
}
