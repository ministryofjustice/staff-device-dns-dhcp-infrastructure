resource "aws_vpc_peering_connection" "vpc_peering_connection" {
  vpc_id      = var.source_vpc_id
  peer_vpc_id = var.target_vpc_id
  auto_accept = true
}
