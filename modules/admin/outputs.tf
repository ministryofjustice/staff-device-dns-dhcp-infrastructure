output "admin_db_identifier" {
  value = aws_db_instance.admin_db.identifier
}

output "admin_url" {
  value = aws_route53_record.admin_app.fqdn
}

output "ecs" {
  value = {
    cluster_name = aws_ecs_cluster.admin_cluster.name
    service_name = aws_ecs_service.admin-service.name
  }
}
