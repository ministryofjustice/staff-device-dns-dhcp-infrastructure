resource "aws_ecs_cluster" "dhcp_cluster" {
  name = "${var.prefix}-cluster"
}

resource "aws_ecs_service" "dhcp_service" {
  name            = "${var.prefix}-service"
  cluster         = "${aws_ecs_cluster.dhcp_cluster.id}"
  task_definition = "${aws_ecs_task_definition.dhcp_task.arn}"
  desired_count   = "1"

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

resource "aws_ecs_task_definition" "dhcp_task" {
  family        = "pttp-test"
  task_role_arn = "${aws_iam_role.ecs-task-role.arn}"

  depends_on = [
    aws_ecr_repository.govwifi-frontend-ecr
  ]

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
        "hostPort": 1530,
        "containerPort": 1530,
        "protocol": "udp"
      },
      {
        "hostPort": 53,
        "containerPort": 53,
        "protocol": "udp"
      }
    ],
    "essential": true,
    "name": "frontend-radius",
    "environment": [
      {
        "name": "AUTHORISATION_API_BASE_URL",
        "value": "test"
      },{
        "name": "LOGGING_API_BASE_URL",
        "value": "test"
      },{
        "name": "BACKEND_API_KEY",
        "value": "test"
      },{
        "name": "HEALTH_CHECK_RADIUS_KEY",
        "value": "test"
      },{
        "name": "HEALTH_CHECK_SSID",
        "value": "test"
      },{
        "name": "HEALTH_CHECK_IDENTITY",
        "value": "test"
      },{
        "name": "HEALTH_CHECK_PASSWORD",
        "value": "test"
      },{
        "name": "SERVICE_DOMAIN",
        "value": "test"
      },{
        "name": "RADIUSD_PARAMS",
        "value": "test"
      },{
        "name": "RACK_ENV",
        "value": "test"
      }
    ],
    "image": "261219435789.dkr.ecr.eu-west-2.amazonaws.com/govwifi-frontend:latest",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.frontend-log-group.name}",
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
