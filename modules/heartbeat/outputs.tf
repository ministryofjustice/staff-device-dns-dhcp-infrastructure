output "cloudwatch" {
  value = {
    dhcp_heartbeat_log_group = aws_cloudwatch_log_group.dhcp_heartbeat.name
  }
}
