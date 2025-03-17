#-----------------------------------------------------------------
### Getting the staff-device-shared-services-infrastructure state
#-----------------------------------------------------------------
data "terraform_remote_state" "staff-device-shared-services-infrastructure" {
  backend = "s3"

  config = {
    bucket = "pttp-global-bootstrap-pttp-infrastructure-tf-remote-state"
    key    = "env:/ci/terraform/v1/state"
    region = "eu-west-2"
  }

  #-----------------------------------------------------------------
  ### Getting xsiam secrets from secret manager
  #-----------------------------------------------------------------

}
data "aws_secretsmanager_secret" "xsiam_endpoint_secrets" {
  name = "/dhcp-server/${terraform.workspace}/xsiam_endpoint_secrets"
}

data "aws_secretsmanager_secret_version" "xsiam_secrets_version" {
  secret_id  = data.aws_secretsmanager_secret.xsiam_endpoint_secrets.id
  version_id = terraform.workspace == "pre-production" ? local.xsiam_secrets_version_pre_production : terraform.workspace == "production" ? local.xsiam_secrets_version_production : local.xsiam_secrets_version_development
}

#-----------------------------------------------------------------
### Getting ssm parameters for variables
#-----------------------------------------------------------------

data "aws_ssm_parameter" "assume_role" {
  name = "/codebuild/pttp-ci-infrastructure-core-pipeline/${terraform.workspace}/assume_role"
}

data "aws_ssm_parameter" "dns_private_zone" {
  provider = aws.env
  name     = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/staff-device/admin/${terraform.workspace}/dns_private_zone"
}

data "aws_ssm_parameter" "dhcp_load_balancer_private_ip_eu_west_2a" {
  provider = aws.env
  name     = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/staff-device/dhcp/${terraform.workspace}/load_balancer_private_ip_eu_west_2a"
}

data "aws_ssm_parameter" "dhcp_load_balancer_private_ip_eu_west_2b" {
  provider = aws.env
  name     = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/staff-device/dhcp/${terraform.workspace}/load_balancer_private_ip_eu_west_2b"
}

data "aws_ssm_parameter" "pdns_ips" {
  name = "/staff-device/dns/pdns/ips"
}

data "aws_ssm_parameter" "azure_federation_metadata_url" {
  name = "/codebuild/pttp-ci-infrastructure-core-pipeline/${terraform.workspace}/azure_federation_metadata_url"
}

data "aws_ssm_parameter" "enable_load_testing" {
  name = "/staff-device/dns-dhcp/${terraform.workspace}/enable_load_testing"
}

data "aws_ssm_parameter" "number_of_load_testing_nodes" {
  name = "/staff-device/dns-dhcp/${terraform.workspace}/number_of_load_testing_nodes"
}

data "aws_ssm_parameter" "enable_rds_admin_bastion" {
  name = "/staff-device/dns-dhcp/${terraform.workspace}/enable_rds_admin_bastion"
}

data "aws_ssm_parameter" "enable_rds_servers_bastion" {
  name = "/staff-device/dns-dhcp/${terraform.workspace}/enable_rds_servers_bastion"
}

data "aws_ssm_parameter" "pdns_ips_list" {
  name            = "/staff-device/dns/pdns/ips_list"
  with_decryption = true
}

data "aws_ssm_parameter" "vpn_hosted_zone_id" {
  name            = "/codebuild/${terraform.workspace}/vpn_hosted_zone_id"
  with_decryption = true
}

data "aws_ssm_parameter" "byoip_pool_id" {
  name            = "/staff-device/dns/${terraform.workspace}/public_ip_pool_id"
  with_decryption = true
}

data "aws_ssm_parameter" "vpn_hosted_zone_domain" {
  name = "/route53/${terraform.workspace}/vpn_hosted_zone_domain"
}

data "aws_ssm_parameter" "dhcp_transit_gateway_id" {
  name            = "/staff-device/dhcp/${terraform.workspace}/transit_gateway_id"
  with_decryption = true
}

data "aws_ssm_parameter" "transit_gateway_route_table_id" {
  name            = "/staff-device/dhcp/${terraform.workspace}/transit_gateway_route_table_id"
  with_decryption = true
}

data "aws_ssm_parameter" "dns_load_balancer_private_ip_eu_west_2a" {
  name            = "/staff-device/dns/${terraform.workspace}/load_balancer_private_ip_eu_west_2a"
  with_decryption = true
}


data "aws_ssm_parameter" "dns_load_balancer_private_ip_eu_west_2b" {
  name            = "/staff-device/dns/${terraform.workspace}/load_balancer_private_ip_eu_west_2b"
  with_decryption = true
}

data "aws_ssm_parameter" "dns_route53_resolver_ip_eu_west_2a" {
  name            = "/staff-device/dns/${terraform.workspace}/dns_route53_resolver_ip_eu_west_2a"
  with_decryption = true
}

data "aws_ssm_parameter" "dns_route53_resolver_ip_eu_west_2b" {
  name            = "/staff-device/dns/${terraform.workspace}/dns_route53_resolver_ip_eu_west_2b"
  with_decryption = true
}

data "aws_ssm_parameter" "bastion_allowed_ingress_ip" {
  name            = "/staff-device/corsham_testing/bastion_allowed_ingress_ip"
  with_decryption = true
}

data "aws_ssm_parameter" "bastion_allowed_egress_ip" {
  name            = "/staff-device/corsham_testing/bastion_allowed_egress_ip"
  with_decryption = true
}

data "aws_ssm_parameter" "enable_corsham_test_bastion" {
  name            = "/staff-device/dns-dhcp/${terraform.workspace}/enable_bastion"
  with_decryption = true
}

data "aws_ssm_parameter" "corsham_vm_ip" {
  name            = "/staff-device/corsham_testing/corsham_vm_ip"
  with_decryption = true
}

data "aws_ssm_parameter" "model_office_vm_ip" {
  name            = "/staff-device/dns-dhcp/model_office_vm_ip"
  with_decryption = true
}

data "aws_ssm_parameter" "allowed_ip_ranges" {
  name = "/staff-device/dns-dhcp/admin/${terraform.workspace}/allowed_ip_ranges"
}

data "aws_ssm_parameter" "shared_services_account_id" {
  name            = "/codebuild/staff_device_shared_services_account_id"
  with_decryption = true
}

data "aws_ssm_parameter" "dhcp_dns_slack_webhook" {
  name = "/staff-device/sns/dhcp_dns_slack_webhook"
  with_decryption = true
}