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

output "iam" {
  value = {
    ecs_task_role_arn = aws_iam_role.ecs_task_role.arn
    ecs_execution_role_arn = aws_iam_role.ecs_execution_role.arn
  }
}

output "s3" {
  value = {
    bucket_id = aws_s3_bucket.config_bucket.id
    bucket_arn = aws_s3_bucket.config_bucket.arn
    bucket_key_arn = aws_kms_key.config_bucket_key.arn
  }
}
