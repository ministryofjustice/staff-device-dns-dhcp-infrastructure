data "aws_caller_identity" "current" {}

resource "aws_ecs_task_definition" "server_task" {
  family                   = "${var.prefix}-server-task"
  task_role_arn            = module.dns_dhcp_common.iam.ecs_task_role_arn
  execution_role_arn       = module.dns_dhcp_common.iam.ecs_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "1024"
  memory                   = "2048"
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 53,
        "containerPort": 53,
        "protocol": "udp"
      },
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "essential": true,
    "name": "dns-server",
    "environment": [
      {
        "name": "BIND_CONFIG_BUCKET_NAME",
        "value": "${var.prefix}-config-bucket"
      },
      {
        "name": "SENTRY_CURRENT_ENV",
        "value": "${var.short_prefix}"
      }
    ],
    "secrets": [
      {
        "name": "SENTRY_DSN",
        "valueFrom": "${var.secret_arns["staff_device_dns_sentry_dsn"]}"
      },
      {
        "name": "DNS_HEALTH_CHECK_URL",
        "valueFrom": "${var.ssm_arns["DNS_HEALTH_CHECK_URL"]}"
      }
    ],
    "image": "${module.dns_dhcp_common.ecr.repository_url}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${module.dns_dhcp_common.cloudwatch.server_log_group_name}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "eu-west-2-docker-logs"
      }
    },
    "expanded": true
  }
]
EOF
}
