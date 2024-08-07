data "aws_caller_identity" "current" {}

locals {
  memory = terraform.workspace == "production" || terraform.workspace == "pre-production" ? "4096" : "1024"
  cpu    = terraform.workspace == "production" || terraform.workspace == "pre-production" ? "2048" : "512"
}

resource "aws_ecs_task_definition" "server_task" {
  family                   = "${var.prefix}-server-task"
  task_role_arn            = var.ecs_task_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
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
        "value": "${var.dhcp_server_db_name}"
      },
      {
        "name": "DB_HOST",
        "value": "${var.dhcp_db_host}"
      },
      {
        "name": "DB_PORT",
        "value": "3306"
      },
      {
        "name": "INTERFACE",
        "value": "eth0"
      },
      {
        "name": "KEA_CONFIG_BUCKET_NAME",
        "value": "${var.kea_config_bucket_name}"
      },
      {
        "name": "ECS_ENABLE_CONTAINER_METADATA",
        "value": "true"
      },
      {
        "name": "SERVER_NAME",
        "value": "standby"
      },
      {
        "name": "PUBLISH_METRICS",
        "value": "true"
      },
      {
        "name": "METRICS_NAMESPACE",
        "value": "${var.metrics_namespace}"
      },
      {
        "name": "HEARTBEAT_SUBNET_ID",
        "value": "2"
      }
    ],
    "secrets": [
      {
        "name": "DB_USER",
        "valueFrom": "${var.secret_arns["codebuild_dhcp_env_db"]}:username::"

      },
      {
        "name": "DB_PASS",
         "valueFrom": "${var.secret_arns["codebuild_dhcp_env_db"]}:password::"
      },
      {
        "name": "PRIMARY_IP",
        "valueFrom": "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/staff-device/dhcp/${var.env}/load_balancer_private_ip_eu_west_2a"
      },
      {
        "name": "STANDBY_IP",
        "valueFrom": "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/staff-device/dhcp/${var.env}/load_balancer_private_ip_eu_west_2b"
      }
    ], 
    "image": "${var.dhcp_repository_url}",
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.server_log_group.name}",
        "awslogs-region": "eu-west-2",
        "awslogs-stream-prefix": "eu-west-2-docker-logs"
      }
    },
    "expanded": true
  }, {
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "${aws_cloudwatch_log_group.server_nginx_log_group.name}",
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
    "image": "${var.nginx_repository_url}",
    "name": "NGINX"
  }
]
EOF
}
