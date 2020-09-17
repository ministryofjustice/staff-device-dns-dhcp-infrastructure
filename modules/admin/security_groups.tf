resource "aws_security_group" "admin_alb" {
  name        = "${var.prefix}-alb"
  description = "Allow Traffic to the Admin Portal"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "admin_alb_out" {
  type                     = "egress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.admin_alb.id
  source_security_group_id = aws_security_group.admin_ecs.id
}

resource "aws_security_group" "admin_db" {
  name        = "${var.prefix}-db"
  description = "Allow connections to the DB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.admin_ecs.id]
  }

  tags = var.tags
}

resource "aws_security_group" "admin_ecs" {
  name        = "${var.prefix}-ecs"
  description = "Allow traffic to and from Admin ECS"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_security_group_rule" "admin_ecs_in" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.admin_ecs.id
  source_security_group_id = aws_security_group.admin_alb.id
}
