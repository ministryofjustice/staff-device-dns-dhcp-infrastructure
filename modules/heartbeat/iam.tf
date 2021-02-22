resource "aws_iam_role" "dns_dhcp_heartbeat_role" {
  name               = "${var.prefix}"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "dns_dhcp_heartbeat" {
  role       = aws_iam_role.dns_dhcp_heartbeat_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "dns_dhcp_heartbeat" {
  name = var.prefix
  role = aws_iam_role.dns_dhcp_heartbeat_role.name
}
