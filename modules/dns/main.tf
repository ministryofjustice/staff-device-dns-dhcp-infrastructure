module "dns_dhcp_common" {
  source                              = "../dns_dhcp_common"
  prefix                              = var.prefix
  vpc_id                              = var.vpc_id
  tags                                = var.tags
  subnets                             = var.subnets
  container_name                      = "dns-server"
  container_port                      = "53"
  security_group_id                   = aws_security_group.dns_server.id
  task_definition_arn                 = aws_ecs_task_definition.server_task.arn
  service_ip                          = var.service_ip
  critical_notifications_arn          = var.critical_notifications_arn
}
