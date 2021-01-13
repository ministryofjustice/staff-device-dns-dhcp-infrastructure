resource "aws_cloudwatch_log_metric_filter" "kea_dhcp_filter" {
  for_each = toset(var.dhcp_log_search_metric_filters)

  name           = each.value
  pattern        = each.value
  log_group_name = module.dns_dhcp_common.cloudwatch.server_log_group_name

  metric_transformation {
    name          = each.value
    namespace     = var.metrics_namespace
    value         = "1"
    default_value = "0"
  }
}
