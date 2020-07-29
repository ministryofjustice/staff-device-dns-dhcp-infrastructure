resource "aws_ssm_parameter" "kea_server_db_hostname" {
  name      = "/codebuild/dhcp/${var.env}/db/hostname"
  type      = "String"
  value     = aws_db_instance.dhcp_server_db.endpoint
  overwrite = true
  tags      = var.tags
}
