module "dns_dhcp_common" {
  source              = "../dns_dhcp_common"
  prefix              = var.prefix
  vpc_id              = var.vpc_id
  tags                = var.tags
  subnets             = var.subnets
  container_name      = "dns-server"
  container_port      = "53"
  security_group_id   = aws_security_group.dns_server.id
  task_definition_arn = aws_ecs_task_definition.server_task.arn
  desired_count       = 2
  max_capacity        = 6
  min_capacity        = 2
  has_api_service     = false

  load_balancer_config = {
    eu_west_2a = {
      subnet_id            = var.subnets[0]
      private_ipv4_address = var.load_balancer_private_ip_eu_west_2a
    },
    eu_west_2b = {
      subnet_id            = var.subnets[1]
      private_ipv4_address = var.load_balancer_private_ip_eu_west_2b
    }
  }

}
