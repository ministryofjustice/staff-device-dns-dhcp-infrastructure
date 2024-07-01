resource "aws_ssm_parameter" "codebuild_dhcp_env_db_username" {
  name  = "/codebuild/dhcp/${var.env}/db/username"
  type  = "SecureString"
  value = "dhcpuser"
}

resource "aws_ssm_parameter" "codebuild_dhcp_env_db_password" {
  name  = "/codebuild/dhcp/${var.env}/db/password"
  provider = "aws.env"
  type  = "SecureString"
  value = random_password.codebuild_dhcp_env_db_password.result
}

resource "random_password" "codebuild_dhcp_env_db_password" {
  length           = 24
  override_special = "!#$%&*()-_=+[]{}<>:?"

  lifecycle {
    ignore_changes = [
      length,
      override_special
    ]
  }
}
#
# resource "aws_ssm_parameter" "staff_device_dhcp_env_load_balancer_private_ip_eu_west_2a" {
#   name  = "/staff-device/dhcp/${var.env}/load_balancer_private_ip_eu_west_2a"
#   type  = "SecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "staff_device_dhcp_env_load_balancer_private_ip_eu_west_2b" {
#   name  = "/staff-device/dhcp/${var.env}/load_balancer_private_ip_eu_west_2b"
#   type  = "SecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "staff_device_dhcp_sentry_dsn" {
#   name  = "/staff-device/dhcp/sentry_dsn"
#   type  = "SecureString"
#   value = "UPDATE_ME"
# }
#
# resource "aws_ssm_parameter" "staff_device_dns_sentry_dsn" {
#   name  = "/staff-device/dns/sentry_dsn"
#   type  = "SecureString"
#   value = "UPDATE_ME"
# }
#
# resource "aws_ssm_parameter" "codebuild_dhcp_env_admin_api_basic_auth_password" {
#   name  = "/codebuild/dhcp/${var.env}/admin/api/basic_auth_password"
#   type  = "SecureSecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "codebuild_dhcp_env_admin_api_basic_auth_username" {
#   name  = "/codebuild/dhcp/${var.env}/admin/api/basic_auth_username"
#   type  = "SecureSecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "codebuild_dhcp_env_admin_api_endpoint" {
#   name  = "/codebuild/dhcp/${var.env}/admin/api/endpoint"
#   type  = "SecureSecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "codebuild_dhcp_env_admin_db_hostname" {
#   name  = "/codebuild/dhcp/${var.env}/admin/db/hostname"
#   type  = "SecureSecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "codebuild_dhcp_env_admin_db_name" {
#   name  = "/codebuild/dhcp/${var.env}/admin/db/name"
#   type  = "SecureSecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "staff_device_admin_sentry_dsn" {
#   name  = "/staff-device/admin/sentry_dsn"
#   type  = "SecureSecureString"
#   value = "UPDATE_ME"
# }
#
# resource "aws_ssm_parameter" "staff_device_admin_env_dns_private_zone" {
#   name  = "/staff-device/admin/${var.env}/dns_private_zone"
#   type  = "SecureSecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "codebuild_dhcp_env_admin_db_username" {
#   name  = "/codebuild/dhcp/${var.env}/admin/db/username"
#   type  = "SecureSecureString"
#   value = "bar"
# }
#
# resource "aws_ssm_parameter" "codebuild_dhcp_env_admin_db_password" {
#   name  = "/codebuild/dhcp/${var.env}/admin/db/password"
#   type  = "SecureSecureString"
#   value = "bar"
# }

