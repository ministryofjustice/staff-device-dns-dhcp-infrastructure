resource "aws_kinesis_firehose_delivery_stream" "xsiam_delivery_stream" {
  name        = "xsiam-delivery-stream-${var.prefix}"
  destination = "http_endpoint"

  tags = var.tags

  server_side_encryption {
    enabled = true
  }

  http_endpoint_configuration {
    url                = var.http_endpoint
    name               = var.prefix
    access_key         = var.access_key
    buffering_size     = 5
    buffering_interval = 300
    role_arn           = aws_iam_role.xsiam_kinesis_firehose_role.arn
    s3_backup_mode     = "FailedDataOnly"

    s3_configuration {
      role_arn           = aws_iam_role.xsiam_kinesis_firehose_role.arn
      bucket_arn         = aws_s3_bucket.xsiam_firehose_bucket.arn
      buffering_size     = 10
      buffering_interval = 400
      compression_format = "GZIP"
    }
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = aws_cloudwatch_log_group.xsiam_delivery_group.name
      log_stream_name = aws_cloudwatch_log_stream.xsiam_delivery_stream.name
    }
  }

}

resource "aws_cloudwatch_log_group" "xsiam_delivery_group" {
  name              = "xsiam-delivery-stream-${var.prefix}"
  tags              = var.tags
  retention_in_days = 90
}

resource "aws_cloudwatch_log_stream" "xsiam_delivery_stream" {
  name           = "errors"
  log_group_name = aws_cloudwatch_log_group.xsiam_delivery_group.name
}

resource "aws_iam_role" "xsiam_kinesis_firehose_role" {

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "xsiam_kinesis_firehose_role_policy" {
  role = aws_iam_role.xsiam_kinesis_firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:GetLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "kinesis_firehose_error_log_role_attachment" {
  policy_arn = aws_iam_policy.xsiam_kinesis_firehose_error_log_policy.arn
  role       = aws_iam_role.xsiam_kinesis_firehose_role.name

}

resource "aws_iam_policy" "xsiam_kinesis_firehose_error_log_policy" {
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:PutLogEvents",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_cloudwatch_log_group.xsiam_delivery_group.arn}/*"
        ]
      }
    ]
  })

  tags = var.tags
}


resource "aws_iam_role_policy_attachment" "kinesis_role_attachment" {
  policy_arn = aws_iam_policy.s3_kinesis_xsiam_policy.arn
  role       = aws_iam_role.xsiam_kinesis_firehose_role.name

}

resource "aws_iam_policy" "s3_kinesis_xsiam_policy" {

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.xsiam_firehose_bucket.arn,
          "${aws_s3_bucket.xsiam_firehose_bucket.arn}/*"
        ]
      }
    ]
  })

  tags = var.tags
}
