module "dns_dhcp_common" {
  source                              = "../dns_dhcp_common"
  prefix                              = var.prefix
  tags                                = var.tags
  subnets                             = var.private_subnets
  vpc_id                              = var.vpc_id
  security_group_id                   = aws_security_group.dhcp_server.id
  container_port                      = "67"
  container_name                      = "dhcp-server"
  task_definition_arn                 = aws_ecs_task_definition.server_task.arn
  load_balancer_private_ip_eu_west_2a = var.load_balancer_private_ip_eu_west_2a
  load_balancer_private_ip_eu_west_2b = var.load_balancer_private_ip_eu_west_2b
  api_lb_target_group_arn             = aws_lb_target_group.http_api_target_group.arn
  has_api_lb                          = true
  desired_count                       = 2
  max_capacity                        = 4
  min_capacity                        = 2
}
