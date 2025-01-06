resource "aws_secretsmanager_secret" "staff_device_dns_sentry_dsn_1" {
  name = "/staff-device/dns/sentry_dsn"
  #   description = "DNS - Sentry - Application monitoring and debugging software - Data Source Name (DSN)."
  provider = aws.env
  #   tags = merge(local.tags_dns_minus_name,
  #     { "Name" : "/staff-device/dns/sentry_dsn" }
  #   )
}

resource "aws_secretsmanager_secret_version" "staff_device_dns_sentry_dsn" {
  provider      = aws.env
  secret_id     = aws_secretsmanager_secret.staff_device_dns_sentry_dsn_1.id
  secret_string = "REPLACE_ME"
}

resource "aws_ssm_parameter" "dns_health_check_url" {
  provider = aws.env
  name     = "DNS_HEALTH_CHECK_URL"
  type     = "String"
  value    = "gov.uk"
}
