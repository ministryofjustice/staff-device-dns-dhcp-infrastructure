
locals {
  name               = "${var.name}-${random_string.this.result}"
  cloudwatch_prepend = "/aws/ec2/"
  # We use basename of the id to ensure dependency-order
  cloudwatch_loggroup_name = "${local.cloudwatch_prepend}${basename(aws_cloudwatch_log_group.ssm_log.id)}"

}

# Creating a random string for name interpolation
resource "random_string" "this" {
  length  = 5
  special = false
}


resource "aws_cloudwatch_log_group" "ssm_log" {
  name              = "${local.cloudwatch_prepend}${local.name}"
  retention_in_days = var.log_retention
  kms_key_id        = aws_kms_key.this.arn

}
