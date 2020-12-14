module "dns_dhcp_common" {
  source                  = "../dns_dhcp_common"
  prefix                  = var.prefix
  tags                    = var.tags
  vpc_id                  = var.vpc_id
}
