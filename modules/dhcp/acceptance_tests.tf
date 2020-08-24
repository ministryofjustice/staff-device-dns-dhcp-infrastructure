resource "aws_ecr_repository" "docker_dhcp_acceptance_test_repository" {
  name                 = "${var.prefix}-docker-acceptance-test"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_cloudwatch_log_group" "acceptance_test_log_group" {
  name  = "${var.prefix}-docker-acceptance-test"

  retention_in_days = 7
}

resource "aws_ecs_task_definition" "acceptance_test_task" {
  family        = "${var.prefix}-acceptance-test-task"
  task_role_arn = aws_iam_role.ecs_task_role.arn

  # Port 80 is required to be mapped for healthchecks over TCP
  container_definitions = <<EOF
[
  {
    "memory": 1500,
    "portMappings": [
      {
        "hostPort": 80,
        "containerPort": 80,
        "protocol": "tcp"
      },
      {
        "hostPort": 68,
        "containerPort": 68,
        "protocol": "udp"
      }
    ],
    "essential": true,
    "name": "dhcp-acceptance-test",
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
        "name": "KEA_CONFIG_BUCKET_NAME",
        "value": "${var.prefix}-config-bucket"
      },
      {
        "name": "ENV",
        "value": "test"
      }
    ],
    "image": "${aws_ecr_repository.docker_dhcp_acceptance_test_repository.repository_url}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.acceptance_test_log_group.name}",
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
