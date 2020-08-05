resource "aws_cloudwatch_metric_alarm" "db_cpualarm" {
  alarm_name          = "${var.prefix}-db-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions = {
    DBInstanceIdentifier = var.admin_db_identifier
  }

  alarm_description  = "This metric monitors the cpu utilization of the DB."
  alarm_actions      = [aws_sns_topic.this.arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_memoryalarm" {
  alarm_name          = "${var.prefix}-db-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "524288000"

  dimensions = {
    DBInstanceIdentifier = var.admin_db_identifier
  }

  alarm_description  = "This metric monitors the freeable memory available for the DB."
  alarm_actions      = [aws_sns_topic.this.arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_storagealarm" {
  alarm_name          = "${var.prefix}-db-storage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "21474836480"

  dimensions = {
    DBInstanceIdentifier = var.admin_db_identifier
  }

  alarm_description  = "This metric monitors the storage space available for the DB."
  alarm_actions      = [aws_sns_topic.this.arn]
  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "db_burstbalancealarm" {
  alarm_name          = "${var.prefix}-db-burstbalanace-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = "180"
  statistic           = "Minimum"
  threshold           = "45"

  dimensions = {
    DBInstanceIdentifier = var.admin_db_identifier
  }

  alarm_description  = "This metric monitors the IOPS burst balance available for the DB."
  alarm_actions      = [aws_sns_topic.this.arn]
  treat_missing_data = "missing"
}
