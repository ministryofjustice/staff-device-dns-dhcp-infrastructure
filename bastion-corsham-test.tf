module "corsham_test_bastion" {
  source = "./modules/corsham_test"

  bastion_allowed_egress_ip  = var.bastion_allowed_egress_ip
  bastion_allowed_ingress_ip = var.bastion_allowed_ingress_ip
  corsham_vm_ip              = var.corsham_vm_ip
  route_table_id             = module.servers_vpc.public_route_table_ids[0]
  subnets                    = module.servers_vpc.public_subnets
  tags                       = module.dhcp_label.tags
  transit_gateway_id         = var.dhcp_transit_gateway_id
  vpc_id                     = module.servers_vpc.vpc_id

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }

  count = var.enable_corsham_test_bastion == true ? 1 : 0
}
