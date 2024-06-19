
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
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/db/username"
}

data "aws_ssm_parameter" "dhcp_db_password" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/db/password"
}

data "aws_ssm_parameter" "admin_db_username" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/admin/db/username"
}

data "aws_ssm_parameter" "admin_db_password" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/admin/db/password"
}

data "aws_ssm_parameter" "dns_private_zone" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/staff-device/admin/${var.env}/dns_private_zone"
}

data "aws_ssm_parameter" "api_basic_auth_username" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/admin/api/basic_auth_username"
}

data "aws_ssm_parameter" "api_basic_auth_password" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/admin/api/basic_auth_password"
}

data "aws_ssm_parameter" "dhcp_load_balancer_private_ip_eu_west_2a" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/staff-device/dhcp/${var.env}/load_balancer_private_ip_eu_west_2a"
}

data "aws_ssm_parameter" "dhcp_load_balancer_private_ip_eu_west_2b" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/staff-device/dhcp/${var.env}/load_balancer_private_ip_eu_west_2b"
}
