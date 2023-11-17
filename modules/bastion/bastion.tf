terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.26.0"
    }
  }
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.small"
  count         = var.number_of_bastions

  vpc_security_group_ids = setunion(var.security_group_ids, [aws_security_group.bastion.id])

  subnet_id                            = var.private_subnets[0]
  monitoring                           = true
  associate_public_ip_address          = var.associate_public_ip_address
  iam_instance_profile                 = aws_iam_instance_profile.this.id
  instance_initiated_shutdown_behavior = "terminate"
  tags                                 = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  #   filter {
  #   name = "tag:env_${terraform.workspace}"
  #   values = ["true"]
  # }

  owners = ["683290208331"] # shared services accunt
}
