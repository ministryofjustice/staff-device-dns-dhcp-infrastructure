resource "aws_ecs_cluster" "server_cluster" {
  name = "${var.prefix}-cluster"
}

resource "aws_ecs_task_definition" "server_task" {
  family        = "${var.prefix}-server-task"
  task_role_arn = aws_iam_role.ecs_task_role.arn

  # Port 3000 is required to be mapped for healthchecks over TCP
  container_definitions = <<EOF
[
  {
    "memory": 1500,
    "portMappings": [
      {
        "hostPort": 3000,
        "containerPort": 3000,
        "protocol": "tcp"
      },
      {
        "hostPort": 67,
        "containerPort": 67,
        "protocol": "udp"
      }
    ],
    "essential": true,
    "name": "dhcp-server",
    "environment": [
      {
        "name": "DB_NAME",
        "value": "${aws_db_instance.dhcp_server_db.name}"
      },
      {
        "name": "DB_USER",
        "value": "${var.dhcp_db_username}"
      },
      {
        "name": "DB_PASS",
        "value": "${var.dhcp_db_password}"
      },
      {
        "name": "DB_HOST",
        "value": "${aws_db_instance.dhcp_server_db.address}"
      },
      {
        "name": "DB_PORT",
        "value": "${aws_db_instance.dhcp_server_db.port}"
      },
      {
        "name": "INTERFACE",
        "value": "eth0"
      },
      {
        "name": "ENV",
        "value": "test"
      }
    ],
    "image": "${aws_ecr_repository.docker_dhcp_repository.repository_url}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.server_log_group.name}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "eu-west-2-docker-logs"
      }
    },
    "cpu": 1000,
    "expanded": true
  }
]
EOF
}

resource "aws_ecs_service" "service" {
  name            = "${var.prefix}-service"
  cluster         = aws_ecs_cluster.server_cluster.id
  task_definition = aws_ecs_task_definition.server_task.arn
  desired_count   = "1"

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecr_repository" "docker_dhcp_repository" {
  name                 = "${var.prefix}-docker-dhcp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_authorization_token" "token" {
}
