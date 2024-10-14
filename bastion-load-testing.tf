module "load_testing_label" {
  source       = "./modules/label"
  service_name = "dns-bastion"
  owner_email  = var.owner_email
}

module "load_testing" {
  source             = "github.com/ministryofjustice/diso-devops-module-ssm-bastion.git?ref=1fa79052e1e19a9dd3d18953db3db1b80c098986"
  ami_owners         = ["${local.shared_services_account_id}"]
  assume_role        = local.s3-mojo_file_transfer_assume_role_arn
  number_of_bastions = local.number_of_load_testing_nodes
  prefix             = module.load_testing_label.id
  subnets            = module.servers_vpc.vpc.private_subnets
  vpc_cidr_block     = module.servers_vpc.vpc.vpc_cidr_block
  vpc_id             = module.servers_vpc.vpc.vpc_id
  tags               = module.load_testing_label.tags

  providers = {
    aws = aws.env
  }

  depends_on = [module.servers_vpc]
  // Set in SSM parameter store, true or false to enable or disable this module.
  count = local.enable_load_testing == true ? 1 : 0
}
