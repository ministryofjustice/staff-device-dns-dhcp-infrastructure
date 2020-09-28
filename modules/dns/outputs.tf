output "bind_config_bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}

output "bind_config_bucket_arn" {
  value = aws_s3_bucket.config_bucket.arn
}

output "bind_config_bucket_key_arn" {
  value = aws_kms_key.config_bucket_key.arn
}
