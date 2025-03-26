resource "aws_appautoscaling_target" "auth_ecs_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  max_capacity       = 18
  min_capacity       = terraform.workspace == "production" ? 15 : 2
  scalable_dimension = "ecs:service:DesiredCount"
}

resource "aws_appautoscaling_scheduled_action" "ecs_morning_scale_up" {
  name               = "ECS morning scale up"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = "cron(0 0 6 ? * MON-FRI)"

  scalable_target_action {
    min_capacity = terraform.workspace == "production" ? 15 : 2
    max_capacity = 18
  }
}

resource "aws_appautoscaling_scheduled_action" "ecs_resume_dynamic_scaling" {
  name               = "ECS resume dynamic scaling"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  schedule           = "cron(0 0 9 ? * MON-FRI)"

  scalable_target_action {
    min_capacity = terraform.workspace == "production" ? 15 : 2
    max_capacity = 18
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_up_average" {
  name               = "ECS Scale Up Average"
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

  depends_on = [aws_appautoscaling_target.auth_ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_policy_up_max" {
  name               = "ECS Scale Up Max"
  service_namespace  = "ecs"
  policy_type        = "StepScaling"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Maximum"
    cooldown                = 300

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }

  depends_on = [aws_appautoscaling_target.auth_ecs_target]
}

resource "aws_appautoscaling_policy" "ecs_policy_down" {
  name               = "ECS Scale Down Average"
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.server_cluster.name}/${aws_ecs_service.service.name}"
  policy_type        = "StepScaling"
  scalable_dimension = "ecs:service:DesiredCount"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"
    cooldown                = 300

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }

  depends_on = [aws_appautoscaling_target.auth_ecs_target]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_average_alarm_high" {
  alarm_name          = "${var.prefix}-ecs-cpu-average-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    ClusterName = aws_ecs_cluster.server_cluster.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_description = "This alarm tells ECS to scale up based on average high CPU"

  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_up_average.arn
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_maximum_alarm_high" {
  alarm_name          = "${var.prefix}-ecs-cpu-maximum-alarm-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"

  dimensions = {
    ClusterName = aws_ecs_cluster.server_cluster.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_description = "This alarm tells ECS to scale up based on maxmium high CPU"

  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_up_max.arn
  ]

  treat_missing_data = "breaching"
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_alarm_low" {
  alarm_name          = "${var.prefix}-ecs-cpu-alarm-low-average"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "25"

  dimensions = {
    ClusterName = aws_ecs_cluster.server_cluster.name
    ServiceName = aws_ecs_service.service.name
  }

  alarm_description = "This alarm tells ECS to scale in based on low CPU usage"

  alarm_actions = [
    aws_appautoscaling_policy.ecs_policy_down.arn
  ]

  treat_missing_data = "breaching"
}
