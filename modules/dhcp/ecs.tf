resource "aws_ecs_cluster" "server_cluster" {
  name = "${var.prefix}-cluster"
}

resource "aws_ecs_task_definition" "server_task" {
  family        = "${var.prefix}-server-task"
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
        "name": "KEA_CONFIG_URL",
        "value": "https://${aws_s3_bucket.config_bucket.bucket_regional_domain_name}/config.json"
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
  desired_count   = "2"

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target_group.arn
    container_name   = "dhcp-server"
    container_port   = "67"
  }
}

resource "aws_ecr_repository" "docker_dhcp_repository" {
  name                 = "${var.prefix}-docker-dhcp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository_policy" "docker_dhcp_repository_policy" {
  repository = aws_ecr_repository.docker_dhcp_repository.name

  policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": "*",
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

resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.prefix}-config-bucket"
  acl    = "private"
  tags   = var.tags
  versioning {
    enabled = true
  }
}

data "template_file" "config_bucket_policy" {
  template = file("${path.module}/policies/config_bucket_policy.json")

  vars = {
    config_bucket_arn = aws_s3_bucket.config_bucket.arn
  }
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = data.template_file.config_bucket_policy.rendered
}
