locals {
  dns_dhcp_vpc_cidr = "10.180.80.0/22"

  s3-mojo_file_transfer_assume_role_arn = data.terraform_remote_state.staff-device-shared-services-infrastructure.outputs.s3-mojo_file_transfer_assume_role_arn
  xsiam_secrets_version_development     = "9e0de226-ed1a-4dbc-a42a-e549ff86fb19"
  xsiam_secrets_version_pre_production  = "f3680e16-7395-4c82-947a-be9b5e09b79c"
  xsiam_secrets_version_production      = "a83ace3e-b154-4992-bde2-bf72e2aa9950"

  ## for resources which requires the tags map without the "Name" value
  ## It uses the "name" attribute internally and concatenates with other attributes
  tags_admin_minus_name = { for k, v in module.admin_label.tags : k => v if !contains(["Name"], k) }
  tags_dhcp_minus_name  = { for k, v in module.dhcp_label.tags : k => v if !contains(["Name"], k) }
  tags_dns_minus_name   = { for k, v in module.dns_label.tags : k => v if !contains(["Name"], k) }

  secret_manager_arns = {
    codebuild_dhcp_env_admin_db   = aws_secretsmanager_secret.codebuild_dhcp_env_admin_db.arn
    codebuild_dhcp_env_db         = aws_secretsmanager_secret.codebuild_dhcp_env_db.arn
    staff_device_dhcp_sentry_dsn  = aws_secretsmanager_secret.staff_device_dhcp_sentry_dsn.arn
    staff_device_dns_sentry_dsn   = aws_secretsmanager_secret.staff_device_dns_sentry_dsn_1.arn
    staff_device_admin_sentry_dsn = aws_secretsmanager_secret.staff_device_admin_sentry_dsn_1.arn
    codebuild_dhcp_env_admin_api  = aws_secretsmanager_secret.codebuild_dhcp_env_admin_api.arn
  }
}
