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
  load_balancer_private_ip_eu_west_2a = var.load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b = var.load_balancer_private_ip_eu_west_2b
  load_balancer_private_ip_eu_west_2c = var.load_balancer_private_ip_eu_west_2c
}
