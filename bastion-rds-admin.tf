module "rds_admin_label" {
  source       = "./modules/label"
  service_name = "rds-admin"
  owner_email  = var.owner_email
}

module "rds_admin" {
  source             = "./modules/bastion"
  prefix             = module.rds_admin_label.id
  vpc_id             = module.servers_vpc.vpc.vpc_id
  vpc_cidr_block     = module.servers_vpc.vpc.vpc_cidr_block
  private_subnets    = module.admin_vpc.public_subnets
  security_group_ids = [module.admin.security_group_ids.admin_ecs]
  number_of_bastions = 1
  //bastion_allowed_ingress_ip = var.bastion_allowed_ingress_ip
  tags = module.rds_admin_label.tags

  providers = {
    aws = aws.env
  }

  depends_on = [module.servers_vpc]
  count      = 1
}
