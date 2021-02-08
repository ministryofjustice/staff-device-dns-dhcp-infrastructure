resource "aws_ecs_cluster" "server_cluster" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "service" {
  name            = "${var.prefix}-primary-service"
  cluster         = aws_ecs_cluster.server_cluster.id
  task_definition = aws_ecs_task_definition.server_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "dhcp-server"
    container_port   = 67
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group_ha.arn
    container_name   = "dhcp-server"
    container_port   = 8000
  }

  network_configuration {
    subnets = [var.private_subnets[0]]

    security_groups = [
      aws_security_group.dhcp_server.id
    ]

    assign_public_ip = true
  }
}

resource "aws_ecs_service" "api_service" {
  name            = "${var.prefix}-api-service"
  cluster         = aws_ecs_cluster.server_cluster.id
  task_definition = aws_ecs_task_definition.api_server_task.arn
  desired_count   = "2"
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_lb_target_group.http_api_target_group.arn
    container_name   = "dhcp-server"
    container_port   = "8000"
  }

  network_configuration {
    subnets = [
      var.private_subnets[0],
      var.private_subnets[1]
    ]

    security_groups = [
      aws_security_group.dhcp_server.id
    ]

    assign_public_ip = true
  }
}
