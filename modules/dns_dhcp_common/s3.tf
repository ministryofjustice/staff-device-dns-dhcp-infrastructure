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

data "template_file" "config_bucket_policy" {
  template = file("${path.module}/policies/config_bucket_policy.json")

  vars = {
    config_bucket_arn = aws_s3_bucket.config_bucket.arn,
    ecs_task_role_arn = aws_iam_role.ecs_task_role.arn
  }
}

resource "aws_s3_bucket_policy" "config_bucket_policy" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = data.template_file.config_bucket_policy.rendered
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
}

