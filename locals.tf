locals {
  dns_dhcp_vpc_cidr = "10.180.80.0/22"

  s3-mojo_file_transfer_assume_role_arn = data.terraform_remote_state.staff-device-shared-services-infrastructure.outputs.s3-mojo_file_transfer_assume_role_arn
}
