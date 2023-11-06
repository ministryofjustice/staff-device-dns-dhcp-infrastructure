resource "aws_security_group" "bastion" {
  name        = var.prefix
  description = "Allow SSH into bastion"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags

  lifecycle {
    create_before_destroy = false
  }
}
