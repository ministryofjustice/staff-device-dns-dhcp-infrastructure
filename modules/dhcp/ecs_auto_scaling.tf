resource "aws_appautoscaling_target" "auth_ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  max_capacity       = 20
  min_capacity       = 2
  scalable_dimension = "ecs:service:DesiredCount"
}

resource "aws_appautoscaling_policy" "ecs_policy_up" {
  name               = "ECS Scale Up"
  service_namespace  = "ecs"
  policy_type        = "StepScaling"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = ["aws_appautoscaling_target.auth_ecs_target"]
}

resource "aws_appautoscaling_policy" "ecs_policy_down" {
  name               = "ECS Scale Down"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  policy_type        = "StepScaling"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = ["aws_appautoscaling_target.auth_ecs_target"]
}

resource "aws_cloudwatch_metric_alarm" "dhcp_ecs_cpu_alarm_high" {
  alarm_name          = "${var.prefix}-dhcp-ecs-cpu-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.server_cluster.name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }

  alarm_description = "This alarm tells ECS to scale up based on high CPU"

  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_up.arn
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "dhcp_ecs_cpu_alarm_low" {
  alarm_name          = "${var.prefix}-dhcp-ecs-cpu-alarm-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "2"

  dimensions = {
    ClusterName = "${aws_ecs_cluster.server_cluster.name}"
    ServiceName = "${aws_ecs_service.service.name}"
  }

  alarm_description = "This alarm tells ECS to scale in based on low CPU usage"

  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_down.arn
  ]

  treat_missing_data = "breaching"
}
