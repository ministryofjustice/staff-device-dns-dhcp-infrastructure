resource "aws_secretsmanager_secret" "codebuild_dhcp_env_db" {
  name        = "/codebuild/dhcp/${terraform.workspace}/db"
#   description = "DHCP - Service RDS Database username & password."
  provider    = aws.env
#   tags = merge(local.tags_dhcp_minus_name,
#     { "Name" : "/codebuild/dhcp/${terraform.workspace}/db" }
#   )
}

data "aws_secretsmanager_secret_version" "codebuild_dhcp_env_db" {
  secret_id = aws_secretsmanager_secret.codebuild_dhcp_env_db.id
  provider  = aws.env
}

resource "aws_secretsmanager_secret_version" "codebuild_dhcp_env_db" {
  provider  = aws.env
  secret_id = aws_secretsmanager_secret.codebuild_dhcp_env_db.id
  secret_string = jsonencode(
    merge(
      {
        "username" : "dhcpuser",
        "password" : random_password.codebuild_dhcp_env_db.result
      },
      module.dhcp.dhcp_db_details
    )
  )
}

resource "random_password" "codebuild_dhcp_env_db" {
  length           = 24
  special          = true
  override_special = "_!%^"

  lifecycle {
    ignore_changes = [
      length,
      override_special
    ]
  }
}

resource "aws_secretsmanager_secret" "staff_device_dhcp_sentry_dsn" {
  name        = "/staff-device/dhcp/sentry_dsn"
#   description = "DHCP - Sentry - Application monitoring and debugging software - Data Source Name (DSN)."
  provider    = aws.env
#   tags = merge(local.tags_dhcp_minus_name,
#     { "Name" : "/staff-device/dhcp/sentry_dsn" }
#   )
}

resource "aws_secretsmanager_secret_version" "staff_device_dhcp_sentry_dsn" {
  provider      = aws.env
  secret_id     = aws_secretsmanager_secret.staff_device_dhcp_sentry_dsn.id
  secret_string = "REPLACE_ME"
}
