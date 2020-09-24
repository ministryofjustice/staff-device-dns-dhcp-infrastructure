resource "aws_ecs_task_definition" "server_task" {
  family                   = "${var.prefix}-server-task"
  task_role_arn            = module.dns_dhcp_common.ecs_task_role_arn
  execution_role_arn       = module.dns_dhcp_common.ecs_task_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"

  # Port 80 is required to be mapped for healthchecks over TCP
  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
<<<<<<< HEAD
=======
        "hostPort": 80,
        "containerPort": 80,
        "protocol": "tcp"
      },
      {
>>>>>>> f478f45... Use Fargate backend for DHCP and DNS clusters (#47)
        "hostPort": 53,
        "containerPort": 53,
        "protocol": "udp"
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
        "name": "CRITICAL_NOTIFICATIONS_ARN",
        "value": "${var.critical_notifications_arn}"
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
  }, {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${module.dns_dhcp_common.cloudwatch.server_log_group_name}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "eu-west-2-docker-logs"
      }
    },
    "portMappings": [
      {
        "hostPort": 80,
        "protocol": "tcp",
        "containerPort": 80
      }
    ],
    "image": "nginx",
    "name": "NGINX"
  }
]
EOF
}
