resource "aws_ecs_cluster" "server_cluster" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_ecs_service" "service" {
  name            = "${var.prefix}-service"
  cluster         = aws_ecs_cluster.server_cluster.id
  task_definition = aws_ecs_task_definition.server_task.arn
  desired_count   = 5
  launch_type     = "FARGATE"
  tags            = var.tags
  enable_execute_command = true

  lifecycle {
    ignore_changes = [desired_count]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "dns-server"
    container_port   = "53"
  }

  network_configuration {
    subnets = var.subnets

    security_groups = [
      aws_security_group.dns_server.id
    ]

    assign_public_ip = false
  }
}
