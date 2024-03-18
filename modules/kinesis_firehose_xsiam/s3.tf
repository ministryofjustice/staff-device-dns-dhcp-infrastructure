resource "aws_s3_bucket" "xsiam_firehose_bucket" {
  bucket = "xsiam-firehose-${var.prefix}"
  tags   = var.tags
}
