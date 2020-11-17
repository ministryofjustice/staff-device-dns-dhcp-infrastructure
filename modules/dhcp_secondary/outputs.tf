output "ecs" {
  value = {
    cluster_name         = aws_ecs_cluster.server_cluster.name
    service_name         = aws_ecs_service.service.name
    service_arn          = aws_ecs_service.service.id
    task_definition_name = aws_ecs_task_definition.server_task.family
  }
}
