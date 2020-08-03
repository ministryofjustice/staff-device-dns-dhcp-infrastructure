resource "aws_cloudwatch_metric_alarm" "dhcp-cluster-cpu-utilization" {
  count               = local.enabled
  alarm_name          = "${var.prefix}-cluster-cpu-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    ClusterName = var.dhcp_cluster_name
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the cpu utilization"
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "dhcp-database-utilization" {
  count               = local.enabled
  alarm_name          = "${var.prefix}-dhcp-database-utilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Average"
  threshold           = "60"

  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }

  alarm_actions = [aws_sns_topic.this.arn]

  alarm_description  = "This alarm monitors the cpu utilization"
  treat_missing_data = "breaching"
}
