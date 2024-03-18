locals {
  dns_dhcp_vpc_cidr = "10.180.80.0/22"

  s3-mojo_file_transfer_assume_role_arn = data.terraform_remote_state.staff-device-shared-services-infrastructure.outputs.s3-mojo_file_transfer_assume_role_arn
  xsiam_secrets_version_development     = "9e0de226-ed1a-4dbc-a42a-e549ff86fb19"
  xsiam_secrets_version_pre_production  = "f3680e16-7395-4c82-947a-be9b5e09b79c"
  xsiam_secrets_version_production      = "a83ace3e-b154-4992-bde2-bf72e2aa9950"
}

