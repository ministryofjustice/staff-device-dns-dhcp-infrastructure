locals {
  metrics_namespace = "Kea-DHCP-Service"

  log_search_terms = var.enable_dhcp_cloudwatch_log_metrics == true ? toset([
    "ERROR",
    "WARN",
    "HTTP_PREMATURE_CONNECTION_TIMEOUT_OCCURRED",
    "ALLOC_ENGINE_V4_ALLOC_ERROR",
    "ALLOC_ENGINE_V4_ALLOC_FAIL",
    "ALLOC_ENGINE_V4_ALLOC_FAIL_CLASSES",
    "DHCP4_PACKET_NAK_0001",
    "HA_SYNC_FAILED",
    "HA_HEARTBEAT_COMMUNICATIONS_FAILED",
    "HA_DHCP_DISABLE_COMMUNICATIONS_FAILED"
  ]) : []
}

resource "aws_cloudwatch_log_metric_filter" "kea_dhcp_filter" {
  for_each = local.log_search_terms

  name           = each.value
  pattern        = each.value
  log_group_name = module.dns_dhcp_common.cloudwatch.server_log_group_name

  metric_transformation {
    name      = each.value
    namespace = local.metrics_namespace
    value     = "1"
    default_value = "0"
  }
}
