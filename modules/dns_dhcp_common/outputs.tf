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
    arn  = aws_lb.load_balancer.arn
  }
}


output "cloudwatch" {
  value = {
    server_log_group_name = aws_cloudwatch_log_group.server_log_group.name
  }
}
