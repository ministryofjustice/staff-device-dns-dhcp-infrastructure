resource "aws_db_instance" "dhcp_server_db" {
  allocated_storage           = 20
  storage_type                = "gp2"
  engine                      = "mysql"
  engine_version              = "5.7"
  auto_minor_version_upgrade  = true
  allow_major_version_upgrade = false
  apply_immediately           = true
  instance_class              = "db.t2.medium" #TODO bump this
  identifier                  = "${var.prefix}-db"
  name                        = replace(var.prefix, "-", "")
  username                    = var.dhcp_db_username
  password                    = var.dhcp_db_password
  backup_retention_period     = "30"
  multi_az                    = true
  storage_encrypted           = true #TODO encrypt
  db_subnet_group_name        = aws_db_subnet_group.db.name
  vpc_security_group_ids      = [aws_security_group.dhcp_db_in.id]
  publicly_accessible         = true
  # monitoring_role_arn         = "${var.rds-monitoring-role}" #TODO set this
  # monitoring_interval         = "${var.db-monitoring-interval}"  #TODO set this
  # maintenance_window          = "${var.db-maintenance-window}" #TODO set this
  # backup_window               = "${var.db-backup-window}" #TODO set this
  skip_final_snapshot         = true
  deletion_protection         = false

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]
  option_group_name               = aws_db_option_group.mariadb_audit.name
  parameter_group_name            = aws_db_parameter_group.db_parameters.name

  tags = var.tags
}

resource "aws_db_option_group" "mariadb_audit" {
  name = "${var.prefix}-db-audit"

  option_group_description = "Mariadb audit configuration for DHCP server database"
  engine_name              = "mysql"
  major_engine_version     = "5.7"

  option {
    option_name = "MARIADB_AUDIT_PLUGIN"
  }

  tags = var.tags
}

resource "aws_db_parameter_group" "db_parameters" {
  name        = "${var.prefix}-admin-db-parameter-group"
  family      = "mysql5.7"
  description = "DB parameter configuration for DHCP server"

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
    name  = "log_bin_trust_function_creators"
    value = 1
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  tags = var.tags
}

resource "aws_db_subnet_group" "db" {
  name       = "${var.prefix}-main"
  subnet_ids = var.subnets

  tags = var.tags
}
