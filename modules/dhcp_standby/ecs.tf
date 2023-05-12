terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.67.0"
    }
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.prefix}-service"
  cluster         = var.dhcp_server_cluster_id
  task_definition = aws_ecs_task_definition.server_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  tags            = var.tags

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_ha.arn
    container_name   = var.container_name
    container_port   = "8000"
  }

  network_configuration {
    subnets = [var.private_subnets[1]]

    security_groups = [
      var.dhcp_server_security_group_id
    ]

    assign_public_ip = false
  }
}

