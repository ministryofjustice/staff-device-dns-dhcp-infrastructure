locals {
  is_production = terraform.workspace == "production" || terraform.workspace == "pre-production" ? true : false
}

data "aws_ssm_parameter" "dhcp_db_username" {
  name = "arn:aws:ssm:eu-west-2:${data.aws_caller_identity.current.account_id}:parameter/codebuild/dhcp/${var.env}/db/username"
}

resource "aws_db_instance" "dhcp_server_db" {
  allocated_storage           = 20
  allow_major_version_upgrade = false
  apply_immediately           = true
  auto_minor_version_upgrade  = true
  backup_retention_period     = local.is_production ? "30" : "0"
  db_subnet_group_name        = aws_db_subnet_group.db.name
  deletion_protection         = local.is_production ? true : false
  engine                      = "mysql"
  engine_version              = "8.0"
  identifier                  = "${var.prefix}-db"
  instance_class              = local.is_production ? "db.t2.large" : "db.t2.medium"
  monitoring_interval         = 30
  monitoring_role_arn         = aws_iam_role.rds_monitoring_role.arn
  multi_az                    = true
  db_name                     = replace(var.prefix, "-", "")
  password                    = var.dhcp_db_password
  publicly_accessible         = false
  skip_final_snapshot         = true
  storage_encrypted           = true
  storage_type                = "gp2"
  username                    = data.aws_ssm_parameter.dhcp_db_username.value
  vpc_security_group_ids      = [aws_security_group.dhcp_db_in.id]

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  parameter_group_name = aws_db_parameter_group.dhcp_db_parameter_group_8_0.name

  tags = var.tags
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.prefix}-main"
  subnet_ids = var.private_subnets

  tags = var.tags
}

resource "aws_db_parameter_group" "dhcp_db_parameter_group" {
  name        = "${var.prefix}-db-parameter-group"
  family      = "mysql5.7"
  description = "DHCP DB parameter group"

  parameter {
    name  = "sql_mode"
    value = "STRICT_ALL_TABLES"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_parameter_group" "dhcp_db_parameter_group_8_0" {
  name        = "${var.prefix}-db-parameter-group-8-0"
  family      = "mysql8.0"
  description = "DHCP DB parameter group"

  parameter {
    name  = "sql_mode"
    value = "STRICT_ALL_TABLES"
  }

  parameter {
    name  = "log_bin_trust_function_creators"
    value = "1"
  }

  lifecycle {
    create_before_destroy = true
  }
}
