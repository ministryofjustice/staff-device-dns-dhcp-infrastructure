variable "subnet_ids" {
  description = "List of AWS subnet IDs to place the EC2 instances and ELB into"
  type        = list(string)
}

variable "secret_key_base" {
  type = string
  description = "Rails secret key base variable used for the admin platform"
}

variable "vpc_id" {
  type = string
  description = "VPC ID used for placing the ALB into"
}

variable "admin_db_username" {
  type = string
}

variable "admin_db_password" {
  type = string
}

variable "sentry_dsn" {
  type = string
}

variable "prefix" {
  type = string
}

variable "short_prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "kea_config_bucket_arn" {
  type = string
}

variable "kea_config_bucket_name" {
  type = string
}

variable "vpn_hosted_zone_id" {
  type = string
}

variable "vpn_hosted_zone_domain" {
  type = string
}

variable "admin_db_backup_retention_period" {
  type = number
}

variable "cognito_user_pool_id" {
  type = string
}

variable "cognito_user_pool_domain" {
  type = string
}

variable "cognito_user_pool_client_id" {
  type = string
}

variable "cognito_user_pool_client_secret" {
  type = string
}
