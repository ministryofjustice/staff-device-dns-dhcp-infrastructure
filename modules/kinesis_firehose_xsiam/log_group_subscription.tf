resource "aws_cloudwatch_log_subscription_filter" "dhcp_server_xsiam_subscription" {
  name            = "dhcp-delivery-stream-${var.prefix}"
  role_arn        = aws_iam_role.this.arn
  log_group_name  = var.cloudwatch_log_group_for_subscription
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.xsiam_delivery_stream.arn
}

resource "aws_iam_role" "this" {
  name_prefix        = var.prefix
  tags               = var.tags
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "logs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "put_record" {
  name_prefix = var.prefix
  tags        = var.tags
  policy      = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "firehose:PutRecord",
                "firehose:PutRecordBatch"
            ],
            "Resource": [
                "${aws_kinesis_firehose_delivery_stream.xsiam_delivery_stream.arn}"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.put_record.arn
}
