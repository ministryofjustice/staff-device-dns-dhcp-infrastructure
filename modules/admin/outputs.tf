output "admin_db_identifier" {
  value = aws_db_instance.admin_db.identifier
}

output "admin_url" {
  value = [for record in aws_route53_record.admin_alb : record.fqdn]
}
