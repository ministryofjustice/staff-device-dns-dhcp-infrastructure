resource "aws_lb" "dhcp_load_balancer" {
  name               = "${var.prefix}-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = var.tags
}
