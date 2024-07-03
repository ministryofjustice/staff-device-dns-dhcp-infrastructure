
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
}
data "aws_secretsmanager_secret" "xsiam_endpoint_secrets" {
  name = "/dhcp-server/${terraform.workspace}/xsiam_endpoint_secrets"
}

data "aws_secretsmanager_secret_version" "xsiam_secrets_version" {
  secret_id  = data.aws_secretsmanager_secret.xsiam_endpoint_secrets.id
  version_id = terraform.workspace == "pre-production" ? local.xsiam_secrets_version_pre_production : terraform.workspace == "production" ? local.xsiam_secrets_version_production : local.xsiam_secrets_version_development
}

data "aws_ssm_parameter" "dhcp_db_username" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/codebuild/dhcp/${terraform.workspace}/db/username"
  #depends_on = [aws_ssm_parameter.codebuild_dhcp_env_db_username]
}

data "aws_ssm_parameter" "dhcp_db_password" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/codebuild/dhcp/${terraform.workspace}/db/password"
  #depends_on = [aws_ssm_parameter.codebuild_dhcp_env_db_password]
}

data "aws_ssm_parameter" "admin_db_username" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/codebuild/dhcp/${terraform.workspace}/admin/db/username"
  #depends_on = [aws_ssm_parameter.codebuild_dhcp_env_admin_db_username]
}

data "aws_ssm_parameter" "admin_db_password" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/codebuild/dhcp/${terraform.workspace}/admin/db/password"
  #depends_on = [aws_ssm_parameter.codebuild_dhcp_env_admin_db_password]
}

data "aws_ssm_parameter" "dns_private_zone" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/staff-device/admin/${terraform.workspace}/dns_private_zone"
  #depends_on = [aws_ssm_parameter.staff_device_admin_env_dns_private_zone]
}

data "aws_ssm_parameter" "api_basic_auth_username" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/codebuild/dhcp/${terraform.workspace}/admin/api/basic_auth_username"
  #depends_on = [aws_ssm_parameter.codebuild_dhcp_env_admin_api_basic_auth_username]
  // "http basic auth username for the dhcp-stats api endpoint"
}

data "aws_ssm_parameter" "api_basic_auth_password" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/codebuild/dhcp/${terraform.workspace}/admin/api/basic_auth_password"
  #depends_on = [aws_ssm_parameter.codebuild_dhcp_env_admin_api_basic_auth_password]
  // "http basic auth password for the dhcp-stats api endpoint"
}

data "aws_ssm_parameter" "dhcp_load_balancer_private_ip_eu_west_2a" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/staff-device/dhcp/${terraform.workspace}/load_balancer_private_ip_eu_west_2a"
  #depends_on = [aws_ssm_parameter.staff_device_dhcp_env_load_balancer_private_ip_eu_west_2a]
}

data "aws_ssm_parameter" "dhcp_load_balancer_private_ip_eu_west_2b" {
  provider = "aws.env"
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.target_account.account_id}:parameter/staff-device/dhcp/${terraform.workspace}/load_balancer_private_ip_eu_west_2b"
  #depends_on = [aws_ssm_parameter.staff_device_dhcp_env_load_balancer_private_ip_eu_west_2b]
}
