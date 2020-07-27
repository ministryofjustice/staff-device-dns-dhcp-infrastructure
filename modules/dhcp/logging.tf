resource "aws_cloudwatch_log_group" "server_log_group" {
  name = "${var.prefix}-server-log-group"

  retention_in_days = 7
}
