
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
