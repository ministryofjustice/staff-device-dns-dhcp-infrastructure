module "dns" {
  source = "./modules/dns"

  dns_route53_resolver_ip_eu_west_2a  = local.dns_route53_resolver_ip_eu_west_2a
  dns_route53_resolver_ip_eu_west_2b  = local.dns_route53_resolver_ip_eu_west_2b
  load_balancer_private_ip_eu_west_2a = local.dns_load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b = local.dns_load_balancer_private_ip_eu_west_2b
  prefix                              = module.dns_label.id
  sentry_dsn                          = var.dns_sentry_dsn
  short_prefix                        = module.dns_label.stage
  subnets                             = module.servers_vpc.private_subnets
  tags                                = module.dns_label.tags
  vpc_cidr                            = local.dns_dhcp_vpc_cidr
  vpc_id                              = module.servers_vpc.vpc_id
  shared_services_account_id          = local.shared_services_account_id
  secret_arns                         = local.secret_manager_arns
  ssm_arns                            = local.ssm_arns

  depends_on = [
    module.servers_vpc
  ]

  providers = {
    aws = aws.env
  }
}
