module "servers_vpc" {
  source = "./modules/servers_vpc"

  byoip_pool_id                          = local.byoip_pool_id
  cidr_block                             = "10.180.80.0/22"
  cidr_block_new_bits                    = 2
  corsham_vm_ip                          = local.corsham_vm_ip
  dhcp_transit_gateway_id                = local.dhcp_transit_gateway_id
  enable_dhcp_transit_gateway_attachment = var.enable_dhcp_transit_gateway_attachment
  model_office_vm_ip                     = local.model_office_vm_ip
  pdns_ips                               = local.pdns_ips_list
  prefix                                 = module.dhcp_label.id
  region                                 = data.aws_region.current_region.id
  tags                                   = module.dhcp_label.tags
  transit_gateway_route_table_id         = local.transit_gateway_route_table_id
  ssm_session_manager_endpoints          = local.enable_load_testing || local.enable_rds_servers_bastion ? true : false

  providers = {
    aws = aws.env
  }
}

module "dhcp_dns_vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"
  prefix = "staff-device-dns-dhcp-${terraform.workspace}"
  region = data.aws_region.current_region.id
  tags   = module.dhcp_label.tags
  vpc_id = module.servers_vpc.vpc_id

  providers = {
    aws = aws.env
  }
}
