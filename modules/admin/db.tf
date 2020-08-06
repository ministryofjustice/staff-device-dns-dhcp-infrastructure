resource "aws_db_parameter_group" "db_parameters" {
  name        = "${var.prefix}-db-parameter-group"
  family      = "mysql5.7"
  description = "DB parameter configuration for admin"

  parameter {
    name  = "slow_query_log"
    value = 1
  }

  parameter {
    name  = "general_log"
    value = 0
  }

  parameter {
    name  = "log_queries_not_using_indexes"
    value = 1
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  tags = var.tags
}

resource "aws_db_option_group" "mariadb_audit" {
  name = "${var.prefix}-db-audit"

  option_group_description = "Mariadb audit configuration for DNS / DHCP admin"
  engine_name              = "mysql"
  major_engine_version     = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }

  tags = var.tags
}

resource "aws_db_instance" "admin_db" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true
  instance_class              = "db.t2.medium"
  identifier                  = "${var.prefix}-db"
  name                        = replace(var.prefix, "-", "")
  username                    = var.admin_db_username
  password                    = var.admin_db_password
  backup_retention_period     = var.admin_db_backup_retention_period
  multi_az                    = true
  storage_encrypted           = true
  db_subnet_group_name        = aws_db_subnet_group.admin_db_group.name
  vpc_security_group_ids      = [aws_security_group.admin_db_in.id]
  monitoring_role_arn         = aws_iam_role.rds_monitoring_role.arn
  monitoring_interval         = 60
  skip_final_snapshot         = true
  deletion_protection         = false

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  option_group_name               = aws_db_option_group.mariadb_audit.name
  parameter_group_name            = aws_db_parameter_group.db_parameters.name

  tags = var.tags
}

resource "aws_db_subnet_group" "admin_db_group" {
  name       = "${var.prefix}-db-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}
