resource "aws_instance" "corsham_testing_bastion" {
  ami             = data.aws_ami.ubuntu.id
  instance_type   = "t2.nano"
  security_groups = [
    aws_security_group.corsham_test_bastion.id
  ]

  subnet_id  = var.subnets[0]
  key_name   = aws_key_pair.testing_bastion_public_key_pair.key_name
  monitoring = true

  instance_initiated_shutdown_behavior = "terminate"

  tags = {
    Name = "Corsham Test Bastion"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "tls_private_key" "ec2" {
  algorithm = "RSA"
}

resource "aws_key_pair" "testing_bastion_public_key_pair" {
  key_name   = "corsham-bastion"
  public_key = tls_private_key.ec2.public_key_openssh
  tags       = var.tags
}

resource "aws_ssm_parameter" "instance_private_key" {
  name        = "/corsham/testing/bastion/private_key"
  type        = "SecureString"
  value       = tls_private_key.ec2.private_key_pem
  overwrite   = true
  description = "SSH key for Corsham jumpbox"
  tags        = var.tags
}
