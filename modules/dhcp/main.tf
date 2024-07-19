module "dns_dhcp_common" {
  source                     = "../dns_dhcp_common"
  prefix                     = var.prefix
  tags                       = var.tags
  vpc_id                     = var.vpc_id
  shared_services_account_id = var.shared_services_account_id
  secret_arns                = var.secret_arns
}
