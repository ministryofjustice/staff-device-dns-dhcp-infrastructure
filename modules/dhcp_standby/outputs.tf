output "ecs" {
  value = {
    service_name = aws_ecs_service.service.name
  }
}
