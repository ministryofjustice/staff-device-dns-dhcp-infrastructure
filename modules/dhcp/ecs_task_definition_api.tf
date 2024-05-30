resource "aws_ecs_task_definition" "api_server_task" {
  family                   = "${var.prefix}-api-server-task"
  task_role_arn            = module.dns_dhcp_common.iam.ecs_task_role_arn
  execution_role_arn       = module.dns_dhcp_common.iam.ecs_execution_role_arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
  {
    "portMappings": [
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
        "value": "${aws_db_instance.dhcp_server_db.db_name}"
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
        "name": "ECS_ENABLE_CONTAINER_METADATA",
        "value": "true"
      },
      {
        "name": "SERVER_NAME",
        "value": "api"
      }
    ],
        "secrets": [
      {  
        "name": "DB_USER",
        "valueFrom": "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/db/username"
      },
      {
        "name": "DB_PASS",
        "valueFrom": "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/db/password"
      }
    ],
    "image": "${module.dns_dhcp_common.ecr.repository_url}",
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
    "image": "${module.dns_dhcp_common.ecr.nginx_repository_url}",
    "name": "NGINX"
  }
]
EOF
}
