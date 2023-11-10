module "rds_admin_label" {
  source       = "./modules/label"
  service_name = "rds-admin"
  owner_email  = var.owner_email
}

module "rds_admin" {
  source             = "./modules/bastion"
  prefix             = module.rds_admin_label.id
  vpc_id             = module.admin_vpc.vpc.vpc_id
  vpc_cidr_block     = module.admin_vpc.vpc.vpc_cidr_block
  private_subnets    = module.admin_vpc.public_subnets
  security_group_ids = [module.admin.security_group_ids.admin_ecs]
  ami_name           = "diso-devops/bastion/rds-admin/ubuntu-jammy-22.04-amd64-server-1.0.1"
  number_of_bastions = 1
  //bastion_allowed_ingress_ip = var.bastion_allowed_ingress_ip
  tags = module.rds_admin_label.tags

  providers = {
    aws = aws.env
  }

  depends_on = [module.servers_vpc]
  // Set in SSM parameter store, true or false to enable or disable this module.
  count = var.enable_rds_admin == true ? 1 : 0
}
