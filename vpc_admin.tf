module "admin_vpc" {
  source = "./modules/vpc"

  cidr_block                    = "10.0.0.0/16"
  prefix                        = "${module.dhcp_label.id}-admin"
  region                        = data.aws_region.current_region.id
  tags                          = module.admin_label.tags
  ssm_session_manager_endpoints = local.enable_rds_admin_bastion

  providers = {
    aws = aws.env
  }
}

module "admin_vpc_flow_logs" {
  source = "./modules/vpc_flow_logs"
  prefix = "staff-device-admin-${terraform.workspace}"
  region = data.aws_region.current_region.id
  tags   = module.admin_label.tags
  vpc_id = module.admin_vpc.vpc_id

  providers = {
    aws = aws.env
  }
}
