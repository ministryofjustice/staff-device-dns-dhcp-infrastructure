resource "aws_ecs_cluster" "server_cluster" {
  name = "${var.prefix}-cluster"

  capacity_providers = [
    aws_ecs_capacity_provider.capacity_provider.name
  ]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = aws_autoscaling_group.auto_scaling_group.name

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.auto_scaling_group.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 80
    }
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.prefix}-service"
  cluster         = aws_ecs_cluster.server_cluster.id
  task_definition = var.task_definition_arn
  desired_count   = "2"

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}

