resource "aws_security_group" "admin_alb_in" {
  name        = "${var.prefix}-admin-alb-in"
  description = "Allow Inbound Traffic to the admin platform ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "admin_alb_out" {
  name        = "${var.prefix}-admin-alb-out"
  description = "Allow Outbound Traffic from the admin platform ALB"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "admin_db_in" {
  name        = "${var.prefix}-admin-db-in"
  description = "Allow connections to the DB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group" "admin_ecs_out" {
  name        = "${var.prefix}-ecs-out"
  description = "Allow outbound traffic from ECS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}
