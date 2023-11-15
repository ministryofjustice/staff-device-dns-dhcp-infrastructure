module "authentication" {
  source = "./modules/authentication"

  admin_url                     = module.admin.admin_url
  azure_federation_metadata_url = var.azure_federation_metadata_url
  enable_authentication         = var.enable_authentication
  prefix                        = module.dhcp_label.id
  region                        = data.aws_region.current_region.id
  tags                          = module.auth_label.tags
  vpn_hosted_zone_domain        = var.vpn_hosted_zone_domain

  providers = {
    aws = aws.env
  }
}
