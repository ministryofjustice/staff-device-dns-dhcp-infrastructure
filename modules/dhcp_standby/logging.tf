resource "aws_cloudwatch_log_group" "server_log_group" {
  name = "${var.prefix}-server-log-group"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "server_nginx_log_group" {
  name = "${var.prefix}-server-nginx-log-group"

  retention_in_days = 7
}

resource "aws_cloudwatch_log_metric_filter" "kea_dhcp_filter" {
  for_each = toset(var.dhcp_log_search_metric_filters)

  name           = "STANDBY_${each.value}"
  pattern        = each.value
  log_group_name = aws_cloudwatch_log_group.server_log_group.name

  metric_transformation {
    name          = "STANDBY_${each.value}"
    namespace     = var.metrics_namespace
    value         = "1"
    default_value = "0"
  }
}
