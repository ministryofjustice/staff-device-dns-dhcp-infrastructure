locals {
  is_production = terraform.workspace == "production" ? true : false
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
  vpc_security_group_ids      = [aws_security_group.admin_db.id]
  monitoring_role_arn         = aws_iam_role.rds_monitoring_role.arn
  monitoring_interval         = 60
  skip_final_snapshot         = true
  deletion_protection         = local.is_production ? true : false
  publicly_accessible         = var.is_publicly_accessible

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = var.tags
}

resource "aws_db_subnet_group" "admin_db_group" {
  name       = "${var.prefix}-db-group"
  subnet_ids = var.subnet_ids

  tags = var.tags
}
