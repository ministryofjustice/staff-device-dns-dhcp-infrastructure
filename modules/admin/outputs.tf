output "admin_db_identifier" {
  value = aws_db_instance.admin_db.identifier
}

output "admin_db_details" {
  value = jsondecode(<<EOF
    {
      "engine": "${aws_db_instance.admin_db.engine}",
      "host": "${aws_db_instance.admin_db.endpoint}",
      "port": "${aws_db_instance.admin_db.port}",
      "dbname": "${aws_db_instance.admin_db.db_name}",
      "dbClusterIdentifier": "${aws_db_instance.admin_db.identifier}"
    }
  EOF
  )
}

output "admin_url" {
  value = aws_route53_record.admin_app.fqdn
}

output "ecs" {
  value = {
    cluster_name         = aws_ecs_cluster.admin_cluster.name
    service_name         = aws_ecs_service.admin-service.name
    task_definition_name = aws_ecs_task_definition.admin_task.family
  }
}

output "ecr" {
  value = aws_ecr_repository.admin_ecr.repository_url
}

output "security_group_ids" {
  value = {
    admin_ecs = aws_security_group.admin_ecs.id
  }
}

output "db" {
  value = {
    arn                 = aws_db_instance.admin_db.arn
    endpoint            = aws_db_instance.admin_db.endpoint
    fqdn                = aws_route53_record.admin_db.fqdn
    id                  = aws_db_instance.admin_db.id
    name                = aws_db_instance.admin_db.db_name
    port                = aws_db_instance.admin_db.port
    rds_monitoring_role = aws_iam_role.rds_monitoring_role.arn
    username            = aws_db_instance.admin_db.username
  }
}
