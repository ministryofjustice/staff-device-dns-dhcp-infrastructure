resource "aws_ecs_cluster" "admin_cluster" {
  name = "${var.prefix}-admin-cluster"

  tags = var.tags
}

resource "aws_cloudwatch_log_group" "admin_log_group" {
  name = "${var.prefix}-admin-log-group"

  retention_in_days = 7

  tags = var.tags
}

resource "aws_ecr_repository" "admin_ecr" {
  name = "${var.prefix}-admin"

  tags = var.tags
}

resource "aws_ecs_task_definition" "admin_task" {
  family                   = "admin-task-${var.prefix}"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.ecs_admin_instance_role.arn
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
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
          "name": "DB_USER",
          "value": "${var.admin_db_username}"
        },{
          "name": "DB_PASS",
          "value": "${var.admin_db_password}"
        },{
          "name": "DB_NAME",
          "value": "${aws_db_instance.admin_db.name}"
        },{
          "name": "DB_HOST",
          "value": "${aws_db_instance.admin_db.address}"
        },{
          "name": "RACK_ENV",
          "value": "production"
        },{
          "name": "SECRET_KEY_BASE",
          "value": "${var.secret_key_base}"
        },{
          "name": "RAILS_LOG_TO_STDOUT",
          "value": "1"
        },{
          "name": "RAILS_SERVE_STATIC_FILES",
          "value": "1"
        },{
          "name": "SENTRY_DSN",
          "value": "${var.sentry_dsn}"
        },{
          "name": "S3_KEA_CONFIG_OBJECT_KEY",
          "value": "config.json"
        }
      ],
      "image": "${aws_ecr_repository.admin_ecr.repository_url}",
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "${aws_cloudwatch_log_group.admin_log_group.name}",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "${var.prefix}-admin-docker-logs"
        }
      },
      "expanded": true
    }
]
EOF
}

resource "aws_ecs_service" "admin-service" {
  depends_on      = [aws_alb_listener.alb_listener]
  name            = "${var.prefix}-admin"
  cluster         = aws_ecs_cluster.admin_cluster.id
  task_definition = aws_ecs_task_definition.admin_task.arn
  desired_count   = 3
  launch_type     = "FARGATE"

  load_balancer {
    target_group_arn = aws_alb_target_group.admin_tg.arn
    container_name   = "admin"
    container_port   = "3000"
  }

  network_configuration {
    subnets = var.subnet_ids

    security_groups = [
      aws_security_group.admin_ecs_out.id
    ]

    assign_public_ip = true
  }
}

resource "aws_alb_target_group" "admin_tg" {
  depends_on           = [aws_lb.admin_alb]
  name                 = "${var.prefix}-tg"
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
