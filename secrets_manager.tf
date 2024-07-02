resource "aws_secretsmanager_secret" "example" {
  name = "/test/${var.env}/db"
}

resource "aws_secretsmanager_secret_version" "rds_credentials" {
  secret_id     = aws_secretsmanager_secret.example.id
  secret_string = merge(tomap(
    {
      "username" : "adminuser",
      "password" : "${random_password.db_password.result}"
    }
  ), "${module.admin.admin_db_details}")
}

resource "random_password" "db_password"{
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


# resource "aws_secretsmanager_secret" "example" {
#   name = "/codebuild/dhcp/${var.env}/db"
# }
#
# resource "aws_secretsmanager_secret" "example" {
#   name = "/staff-device/dhcp/sentry_dsn"
# }
#
# resource "aws_secretsmanager_secret" "example" {
#   name = "/staff-device/dns/sentry_dsn"
# }
#
# resource "aws_secretsmanager_secret" "example" {
#   name = "/codebuild/dhcp/${var.env}/admin/api"
# }
#
# resource "aws_secretsmanager_secret" "example" {
#   name = "/staff-device/admin/sentry_dsn"
# }
# resource "aws_secretsmanager_secret" "example" {
#   name = "/codebuild/dhcp/${var.env}/admin/db"
# }
