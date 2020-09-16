output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "auto_scaling_group" {
  value = {
    name = aws_autoscaling_group.auto_scaling_group.id
    arn  = aws_autoscaling_group.auto_scaling_group.arn
  }
}

output "ecr" {
  value = {
    repository_url = aws_ecr_repository.docker_repository.repository_url
    registry_id    = aws_ecr_repository.docker_repository.registry_id
  }
}

output "ecs" {
  value = {
    cluster_name = aws_ecs_cluster.server_cluster.name
    service_name = aws_ecs_service.service.name
    service_arn  = aws_ecs_service.service.id
  }
}

output "nlb" {
  value = {
    name = aws_lb.load_balancer.id
  }
}


output "cloudwatch" {
  value = {
    server_log_group_name = aws_cloudwatch_log_group.server_log_group.name
  }
}

output "s3" {
  value = {
    config_bucket_arn  = aws_s3_bucket.config_bucket.arn
    config_bucket_name = aws_s3_bucket.config_bucket.id
  }
}
