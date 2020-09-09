output "admin_db_identifier" {
  value = aws_db_instance.admin_db.identifier
}

output "admin_url" {
  value = var.enable_custom_domain_name ? aws_route53_record.admin_lb[0].fqdn : aws_lb.admin_alb.dns_name
}
