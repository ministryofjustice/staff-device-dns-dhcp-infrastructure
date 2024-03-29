resource "aws_cloudwatch_log_group" "server_log_group" {
  name = "${var.prefix}-api-server-log-group"

  retention_in_days = 90
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "server_nginx_log_group" {
  name = "${var.prefix}-api-server-nginx-log-group"

  retention_in_days = 90
  tags              = var.tags
}
