
resource "aws_security_group" "corsham_test_bastion" {
  name        = "corsham-test-bastion"
  description = "Allow SSH into Corsham test bastion"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.corsham_allowed_egress_ip}/32"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.bastion_allowed_ingress_ip}/32"]
  }
}
