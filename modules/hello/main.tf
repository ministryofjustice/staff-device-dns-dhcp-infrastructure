resource "aws_s3_bucket" "b" {
  bucket = "${var.prefix_name}-my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}