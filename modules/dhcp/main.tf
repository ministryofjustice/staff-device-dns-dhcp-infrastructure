module "dns_dhcp_common" {
  source                              = "../dns_dhcp_common"
  prefix                              = var.prefix
  tags                                = var.tags
  subnets                             = var.subnets
  vpc_id                              = var.vpc_id
  security_group_id                   = aws_security_group.dhcp_server.id
  container_port                      = "67"
  container_name                      = "dhcp-server"
  task_definition_arn                 = aws_ecs_task_definition.server_task.arn
  service_ip                          = var.service_ip
  critical_notifications_arn          = var.critical_notifications_arn
  api_lb_target_group_arn             = aws_lb_target_group.http_api_target_group.arn
  has_api_lb                          = true
  desired_count                       = 1
}
