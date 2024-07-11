locals {
  secret_manager_arns = {
    codebuild_dhcp_env_admin_db = aws_secretsmanager_secret.codebuild_dhcp_env_admin_db.arn
    codebuild_dhcp_env_db = aws_secretsmanager_secret.codebuild_dhcp_env_db.arn
    staff_device_dhcp_sentry_dsn = aws_secretsmanager_secret.staff_device_dhcp_sentry_dsn.arn
    staff_device_dns_sentry_dsn = aws_secretsmanager_secret.staff_device_dns_sentry_dsn_1.arn
    staff_device_admin_sentry_dsn = aws_secretsmanager_secret.staff_device_admin_sentry_dsn_1.arn
    codebuild_dhcp_env_admin_api = aws_secretsmanager_secret.codebuild_dhcp_env_admin_api.arn
  }
}

resource "aws_secretsmanager_secret" "codebuild_dhcp_env_admin_db" {
  name     = "/codebuild/dhcp/${terraform.workspace}/admin/db"
  provider = "aws.env"
}

resource "aws_secretsmanager_secret_version" "codebuild_dhcp_env_admin_db" {
  provider  = "aws.env"
  secret_id = aws_secretsmanager_secret.codebuild_dhcp_env_admin_db.id
  secret_string = jsonencode(
    merge(
      {
        "username" : "adminuser",
        "password" : random_password.codebuild_dhcp_env_admin_db.result
      },
      module.admin.admin_db_details
    )
  )
}

resource "random_password" "codebuild_dhcp_env_admin_db" {
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

resource "aws_secretsmanager_secret" "codebuild_dhcp_env_db" {
  name     = "/codebuild/dhcp/${terraform.workspace}/db"
  provider = "aws.env"
}

resource "aws_secretsmanager_secret_version" "codebuild_dhcp_env_db" {
  provider  = "aws.env"
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
  name     = "/staff-device/dhcp/sentry_dsn"
  provider = "aws.env"
}

resource "aws_secretsmanager_secret_version" "staff_device_dhcp_sentry_dsn" {
  provider      = "aws.env"
  secret_id     = aws_secretsmanager_secret.staff_device_dhcp_sentry_dsn.id
  secret_string = "REPLACE_ME"
}

resource "aws_secretsmanager_secret" "staff_device_dns_sentry_dsn_1" {
  name     = "/staff-device/dns/sentry_dsn"
  provider = "aws.env"
}

resource "aws_secretsmanager_secret_version" "staff_device_dns_sentry_dsn" {
  provider      = "aws.env"
  secret_id     = aws_secretsmanager_secret.staff_device_dns_sentry_dsn_1.id
  secret_string = "REPLACE_ME"
}

resource "aws_secretsmanager_secret" "staff_device_admin_sentry_dsn_1" {
  name     = "/staff-device/admin/sentry_dsn"
  provider = "aws.env"
}

resource "aws_secretsmanager_secret_version" "staff_device_admin_sentry_dsn" {
  provider      = "aws.env"
  secret_id     = aws_secretsmanager_secret.staff_device_admin_sentry_dsn_1.id
  secret_string = "REPLACE_ME"
}

resource "aws_secretsmanager_secret" "codebuild_dhcp_env_admin_api" {
  name     = "/codebuild/dhcp/${terraform.workspace}/admin/api"
  provider = "aws.env"
}

resource "aws_secretsmanager_secret_version" "codebuild_dhcp_env_admin_api" {
  provider  = "aws.env"
  secret_id = aws_secretsmanager_secret.codebuild_dhcp_env_admin_api.id
  secret_string = jsonencode(
    merge(
      {
        "endpoint" : "REPLACE_ME",
        "basic_auth_username" : "REPLACE_ME",
        "basic_auth_password" : "REPLACE_ME",
      }
    )
  )
}
