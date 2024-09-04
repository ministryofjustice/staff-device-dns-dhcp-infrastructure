resource "aws_secretsmanager_secret" "codebuild_dhcp_env_admin_db" {
  name = "/codebuild/dhcp/${terraform.workspace}/admin/db"
  #   description = "DNS & DHCP ADMIN - Service RDS Database username & password."
  provider = aws.env
  #   tags = merge(local.tags_admin_minus_name,
  #     { "Name" : "/codebuild/dhcp/${terraform.workspace}/admin/db" }
  #   )
}

data "aws_secretsmanager_secret_version" "codebuild_dhcp_env_admin_db" {
  secret_id = aws_secretsmanager_secret.codebuild_dhcp_env_admin_db.id
  provider  = aws.env
}

resource "aws_secretsmanager_secret_version" "codebuild_dhcp_env_admin_db" {
  provider  = aws.env
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


resource "aws_secretsmanager_secret" "codebuild_dhcp_env_admin_api" {
  name = "/codebuild/dhcp/${terraform.workspace}/admin/api"
  #   description = "DNS & DHCP ADMIN - Prometheus - HTTP API"
  provider = aws.env
  #   tags = merge(local.tags_admin_minus_name,
  #     { "Name" : "/codebuild/dhcp/${terraform.workspace}/admin/api" }
  #   )
}

data "aws_secretsmanager_secret_version" "codebuild_dhcp_env_admin_api" {
  secret_id = aws_secretsmanager_secret.codebuild_dhcp_env_admin_api.id
  provider  = aws.env
}

resource "aws_secretsmanager_secret_version" "codebuild_dhcp_env_admin_api" {
  provider  = aws.env
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

resource "aws_secretsmanager_secret" "staff_device_admin_sentry_dsn_1" {
  name = "/staff-device/admin/sentry_dsn"
  #   description = "DNS & DHCP ADMIN - Sentry - Application monitoring and debugging software - Data Source Name (DSN)."
  provider = aws.env
  #   tags = merge(local.tags_admin_minus_name,
  #     { "Name" : "/staff-device/admin/sentry_dsn" }
  #   )
}

resource "aws_secretsmanager_secret_version" "staff_device_admin_sentry_dsn" {
  provider      = aws.env
  secret_id     = aws_secretsmanager_secret.staff_device_admin_sentry_dsn_1.id
  secret_string = "REPLACE_ME"
}
