module "rds_servers_bastion_label" {
  source       = "./modules/label"
  service_name = "rds-servers-bastion"
  owner_email  = var.owner_email
}

module "rds_servers_bastion" {
  source                      = "github.com/ministryofjustice/diso-devops-module-ssm-bastion.git?ref=1fa79052e1e19a9dd3d18953db3db1b80c098986"
  ami_owners                  = ["${var.shared_services_account_id}"]
  associate_public_ip_address = false
  assume_role                 = local.s3-mojo_file_transfer_assume_role_arn
  number_of_bastions          = 1
  prefix                      = module.rds_servers_bastion_label.id
  security_group_ids          = [module.dhcp.security_group_ids.dhcp_server]
  subnets                     = module.servers_vpc.public_subnets
  vpc_cidr_block              = module.servers_vpc.vpc.vpc_cidr_block
  vpc_id                      = module.servers_vpc.vpc.vpc_id
  tags                        = module.rds_servers_bastion_label.tags

  providers = {
    aws = aws.env
  }

  depends_on = [module.servers_vpc]
  // Set in SSM parameter store, true or false to enable or disable this module.
  count = local.enable_rds_servers_bastion == true ? 1 : 0
}
