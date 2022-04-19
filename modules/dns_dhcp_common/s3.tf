resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.prefix}-config-bucket"
  acl    = "private"
  tags   = var.tags
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.config_bucket_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Id": "ConfigFetch",
        "Statement": [
            {
                "Sid": "Get configuration file",
                "Effect": "Allow",
                "Principal": {
                  "AWS": "${aws_iam_role.ecs_task_role.arn}"
                },
                "Action": "s3:GetObject",
                "Resource": "${aws_s3_bucket.config_bucket.arn}/*"
            }
        ]
    }
  EOF
}

resource "aws_s3_bucket_public_access_block" "config_bucket_public_block" {
  bucket = aws_s3_bucket.config_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_kms_key" "config_bucket_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  enable_key_rotation     = true
}

