resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.prefix}-config-bucket"
  acl    = "private"
  tags   = var.tags
  versioning {
    enabled = true
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

