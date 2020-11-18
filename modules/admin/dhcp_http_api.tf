resource "aws_vpc_endpoint" "dhcp_api_vpc_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = aws_vpc_endpoint_service.dhcp_http_api.service_name
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.dhcp_api_vpc_endpoint.id,
  ]

  subnet_ids = [var.subnet_ids[0]]
}

resource "aws_vpc_endpoint_service" "dhcp_http_api" {
  acceptance_required        = false
  network_load_balancer_arns = [var.dhcp_http_api_load_balancer_arn]
}
