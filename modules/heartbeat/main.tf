resource "aws_cloudwatch_log_group" "dhcp_heartbeat" {
  name = var.prefix

  tags = var.tags
}

resource "aws_cloudwatch_log_metric_filter" "heartbeat_metrics_filter" {
  name           = "heartbeat-failed"
  pattern        = "\"received packets: 0\""
  log_group_name = aws_cloudwatch_log_group.dhcp_heartbeat.name

  metric_transformation {
    name          = "heartbeat-failed"
    namespace     = var.metrics_namespace
    value         = "1"
    default_value = "0"
  }
}

data "template_file" "bootstrap" {
  template = file("${path.module}/boot_dhcp_client.sh")
  vars = {
    dhcp_ip        = var.dhcp_ip
    log_file_path  = "/var/log/dhcp-heartbeat"
    log_group_name = aws_cloudwatch_log_group.dhcp_heartbeat.name
  }
}

data "aws_ami" "ubuntu_latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "dns_dhcp_heartbeat" {
  ami                                  = data.aws_ami.ubuntu_latest.id
  instance_type                        = "t2.small"
  subnet_id                            = var.subnets[0]
  monitoring                           = true
  associate_public_ip_address          = true
  private_ip                           = var.hearbeat_instance_private_static_ip
  iam_instance_profile                 = aws_iam_instance_profile.dns_dhcp_heartbeat.id
  instance_initiated_shutdown_behavior = "terminate"
  user_data                            = data.template_file.bootstrap.rendered

  vpc_security_group_ids = [
    aws_security_group.heartbeat_instance.id
  ]

  tags = var.tags
}
