

resource "aws_sns_topic" "ecs_alarm" {
  count = terraform.workspace == "production" ? 1 : 0
  name  = "dns-max-scaling-ecs-alarm"
}

resource "aws_sns_topic_subscription" "slack_subscription" {
  count     = terraform.workspace == "production" ? 1 : 0
  topic_arn = aws_sns_topic.ecs_alarm.arn
  protocol  = "https"
  endpoint  = var.dhcp_dns_slack_webhook
}

resource "aws_sns_topic_subscription" "email_subscription" {
  count     = terraform.workspace == "production" ? 1 : 0
  topic_arn = aws_sns_topic.ecs_alarm.arn
  protocol  = "email"
  endpoint  = "lauren.taylor-brown@justice.gov.uk"  
}


resource "aws_cloudwatch_metric_alarm" "ecs_max_task_scale_alarm" {
  count                     = terraform.workspace == "production" ? 1 : 0
  alarm_name                = "ecs-max-task-count-alarm"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = 1
  metric_name               = "RunningTaskCount"
  namespace                 = "ECS/ContainerInsights"
  period                    = 60 
  statistic                 = "Maximum"
  threshold                 = 1
  alarm_description         = "Alarm when DNS service ECS task count reaches max number of tasks"

  dimensions = {
    ClusterName = aws_ecs_cluster.server_cluster.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_actions = [
    aws_sns_topic.ecs_alarm.arn
  ]

  ok_actions = [
    aws_sns_topic.ecs_alarm.arn
  ]
}
