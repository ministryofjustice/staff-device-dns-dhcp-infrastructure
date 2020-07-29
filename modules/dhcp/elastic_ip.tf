resource "aws_eip" "public_ip" {
  vpc               = true
  tags = var.tags
}
