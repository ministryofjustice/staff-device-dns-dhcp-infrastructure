module "load_testing_label" {
  source       = "./modules/label"
  service_name = "dns-bastion"
  owner_email  = var.owner_email
}

module "load_testing" {
  source             = "./modules/bastion"
  prefix             = module.load_testing_label.id
  vpc_id             = module.servers_vpc.vpc.vpc_id
  vpc_cidr_block     = module.servers_vpc.vpc.vpc_cidr_block
  private_subnets    = module.servers_vpc.vpc.private_subnets
  number_of_bastions = local.number_of_load_testing_nodes
  assume_role        = local.s3-mojo_file_transfer_assume_role_arn
  tags               = module.load_testing_label.tags

  providers = {
    aws = aws.env
  }

  depends_on = [module.servers_vpc]
  // Set in SSM parameter store, true or false to enable or disable this module.
  count = local.enable_load_testing == true ? 1 : 0
}
