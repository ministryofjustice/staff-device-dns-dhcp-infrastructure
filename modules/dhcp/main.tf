module "dns_dhcp_common" {
  source                  = "../dns_dhcp_common"
  prefix                  = var.prefix
  tags                    = var.tags
  subnets                 = [var.private_subnets[0]]
  vpc_id                  = var.vpc_id
  security_group_id       = aws_security_group.dhcp_server.id
  container_port          = "67"
  container_name          = "dhcp-server"
  task_definition_arn     = aws_ecs_task_definition.server_task.arn
  api_lb_target_group_arn = aws_lb_target_group.http_api_target_group.arn
  has_api_lb              = true
  desired_count           = 1
  max_capacity            = 1
  min_capacity            = 1

  load_balancer_config = {
    eu_west_2a = {
      subnet_id            = var.private_subnets[0]
      private_ipv4_address = var.load_balancer_private_ip_eu_west_2a
    }
  }
}
