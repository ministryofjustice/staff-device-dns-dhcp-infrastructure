locals {
  memory = terraform.workspace == "production" ? "4096" : "1024"
  cpu    = terraform.workspace == "production" ? "2048" : "512"
}

resource "aws_ecs_task_definition" "server_task" {
  family                   = "${var.prefix}-server-task"
  task_role_arn            = module.dns_dhcp_common.iam.ecs_task_role_arn
  execution_role_arn       = module.dns_dhcp_common.iam.ecs_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = local.cpu
  memory                   = local.memory
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
  {
    "portMappings": [
      {
        "hostPort": 67,
        "containerPort": 67,
        "protocol": "udp"
      },
      {
        "hostPort": 8000,
        "containerPort": 8000,
        "protocol": "tcp"
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
        "value": "${aws_route53_record.dhcp_db.fqdn}"
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
        "name": "ECS_ENABLE_CONTAINER_METADATA",
        "value": "true"
      },
      {
        "name": "SERVER_NAME",
        "value": "primary"
      },
      {
        "name": "PRIMARY_IP",
        "value": "${var.load_balancer_private_ip_eu_west_2a}"
      },
      {
        "name": "STANDBY_IP",
        "value": "${var.load_balancer_private_ip_eu_west_2b}"
      },
      {
        "name": "PUBLISH_METRICS",
        "value": "true"
      },
      {
        "name": "METRICS_NAMESPACE",
        "value": "${var.metrics_namespace}"
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
        "awslogs-group": "${module.dns_dhcp_common.cloudwatch.server_nginx_log_group_name}",
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
    "image": "${module.dns_dhcp_common.ecr.nginx_repository_url}",
    "name": "NGINX"
  }
]
EOF
}
