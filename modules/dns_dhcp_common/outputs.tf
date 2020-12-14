output "ecr" {
  value = {
    repository_url       = aws_ecr_repository.docker_repository.repository_url
    registry_id          = aws_ecr_repository.docker_repository.registry_id
    nginx_repository_url = aws_ecr_repository.docker_repository_nginx.repository_url
  }
}

output "cloudwatch" {
  value = {
    server_log_group_name       = aws_cloudwatch_log_group.server_log_group.name
    server_nginx_log_group_name = aws_cloudwatch_log_group.server_nginx_log_group.name
  }
}
