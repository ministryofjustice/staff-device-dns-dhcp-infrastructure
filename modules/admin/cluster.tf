terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.62.0"
    }
  }
}

locals {
  memory = terraform.workspace == "production" || terraform.workspace == "pre-production" ? "4096" : "1024"
  cpu    = terraform.workspace == "production" || terraform.workspace == "pre-production" ? "2048" : "512"
}

resource "aws_ecs_cluster" "admin_cluster" {
  name = "${var.prefix}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "admin_log_group" {
  name = "${var.prefix}-log-group"

  retention_in_days = 90

  tags = var.tags
}

resource "aws_ecr_repository" "admin_ecr" {
  name = var.prefix

  tags = var.tags
}

data "aws_caller_identity" "current" {}

resource "aws_ecr_repository_policy" "admin_docker_dhcp_repository_policy" {
  repository = aws_ecr_repository.admin_ecr.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal":{
              "AWS": ["${data.aws_caller_identity.current.account_id}", "${var.shared_services_account_id}"]
            },
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:PutImage",
                "ecr:InitiateLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:CompleteLayerUpload",
                "ecr:DescribeRepositories",
                "ecr:GetRepositoryPolicy",
                "ecr:ListImages",
                "ecr:DeleteRepository",
                "ecr:BatchDeleteImage",
                "ecr:SetRepositoryPolicy",
                "ecr:DeleteRepositoryPolicy"
            ]
        }
    ]
}
EOF
}

resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  repository = aws_ecr_repository.admin_ecr.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire older versions of untagged images, keeping the latest 15",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 15
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}

EOF
}

resource "aws_ecs_task_definition" "admin_task" {
  family                   = "${var.prefix}-task"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  cpu                      = "512"
  memory                   = "1024"
  network_mode             = "awsvpc"

  container_definitions = <<EOF
[
    {
      "portMappings": [
        {
          "hostPort": 3000,
          "containerPort": 3000,
          "protocol": "tcp"
        }
      ],
      "essential": true,
      "name": "admin",
      "environment": [
        {
          "name": "DB_NAME",
          "value": "${aws_db_instance.admin_db.db_name}"
        },
        {
          "name": "DB_HOST",
          "value": "${aws_route53_record.admin_db.fqdn}"
        },
        {
          "name": "RACK_ENV",
          "value": "production"
        },
        {
          "name": "SECRET_KEY_BASE",
          "value": "${var.secret_key_base}"
        },
        {
          "name": "RAILS_LOG_TO_STDOUT",
          "value": "1"
        },
        {
          "name": "RAILS_SERVE_STATIC_FILES",
          "value": "1"
        },
        {
          "name": "SENTRY_CURRENT_ENV",
          "value": "${var.short_prefix}"
        },
        {
          "name": "S3_KEA_CONFIG_OBJECT_KEY",
          "value": "config.json"
        },
        {
          "name": "KEA_CONFIG_BUCKET",
          "value": "${var.kea_config_bucket_name}"
        },
        {
          "name": "COGNITO_USER_POOL_SITE",
          "value": "https://${var.cognito_user_pool_domain}.auth.${var.region}.amazoncognito.com"
        },
        {
          "name": "DHCP_CLUSTER_NAME",
          "value": "${var.dhcp_cluster_name}"
        },
        {
          "name": "DHCP_SERVICE_NAME",
          "value": "${var.dhcp_service_name}"
        },{
          "name": "DNS_CLUSTER_NAME",
          "value": "${var.dns_cluster_name}"
        },
        {
          "name": "DNS_SERVICE_NAME",
          "value": "${var.dns_service_name}"
        },{
          "name": "S3_BIND_CONFIG_OBJECT_KEY",
          "value": "named.conf"
        },{
          "name": "BIND_CONFIG_BUCKET",
          "value": "${var.bind_config_bucket_name}"
        },
        {
          "name": "PDNS_IPS",
          "value": "${var.pdns_ips}"
        },
        {
          "name": "KEA_CONTROL_AGENT_URI",
          "value": "http://${aws_vpc_endpoint.dhcp_api_vpc_endpoint.dns_entry[0].dns_name}:8000/"
        }
      ],
      "secrets": [
        {
          "name": "DB_USER",
          "valueFrom": "${var.secret_arns["codebuild_dhcp_env_admin_db"]}:username::"
        },
        {
          "name": "DB_PASS",
          "valueFrom": "${var.secret_arns["codebuild_dhcp_env_admin_db"]}:password::"
        },
        {
          "name": "SENTRY_DSN",
          "valueFrom": "${var.secret_arns["staff_device_admin_sentry_dsn"]}"
        },
        {
          "name": "PRIVATE_ZONE",
          "valueFrom": "arn:aws:ssm:${var.region}:${data.aws_caller_identity.current.account_id}:parameter/staff-device/admin/${terraform.workspace}/dns_private_zone"
        },
        {
          "name": "API_BASIC_AUTH_USERNAME",
          "valueFrom": "${var.secret_arns["codebuild_dhcp_env_admin_api"]}:basic_auth_username::"
        },
        {
          "name": "API_BASIC_AUTH_PASSWORD",
          "valueFrom": "${var.secret_arns["codebuild_dhcp_env_admin_api"]}:basic_auth_password::"
        },
        {
          "name": "COGNITO_USER_POOL_ID",
          "valueFrom": "${var.secret_arns["staff_device_admin_env_cognito_userpool_id"]}"
        },
        {
          "name": "COGNITO_CLIENT_SECRET",
          "valueFrom": "${var.secret_arns["staff_device_admin_env_cognito_client_secret"]}"
        },
        {
          "name": "COGNITO_CLIENT_ID",
          "valueFrom": "${var.secret_arns["staff_device_admin_env_cognito_client_id"]}"
        }
    ],
      "image": "${aws_ecr_repository.admin_ecr.repository_url}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.admin_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "${var.prefix}-docker-logs"
        }
      },
      "expanded": true
    }
]
EOF
}

resource "aws_ecs_service" "admin-service" {
  depends_on      = [aws_alb_listener.alb_listener]
  name            = var.prefix
  cluster         = aws_ecs_cluster.admin_cluster.id
  task_definition = aws_ecs_task_definition.admin_task.arn
  desired_count   = 3
  launch_type     = "FARGATE"
  tags            = var.tags

  load_balancer {
    target_group_arn = aws_alb_target_group.admin_tg.arn
    container_name   = "admin"
    container_port   = "3000"
  }

  network_configuration {
    subnets = var.subnet_ids

    security_groups = [
      aws_security_group.admin_ecs.id
    ]

    assign_public_ip = true
  }
}

resource "aws_alb_target_group" "admin_tg" {
  depends_on           = [aws_lb.admin_alb]
  name                 = "${var.short_prefix}-tg"
  port                 = "3000"
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/healthcheck"
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
