variable "enable_authentication" {
  type    = bool
  default = true
}

variable "enable_critical_notifications" {
  type    = bool
  default = false
}

variable "admin_db_backup_retention_period" {
  type    = number
  default = 30
}

variable "enable_dhcp_transit_gateway_attachment" {
  type    = bool
  default = true
}

variable "enable_corsham_test_bastion" {
  type    = bool
  default = false
}

variable "admin_local_development_domain_affix" {
  type    = string
  default = ""
}

variable "admin_sentry_dsn" {
  type    = string
  default = ""
}

variable "dhcp_sentry_dsn" {
  type    = string
  default = ""
}

variable "dns_sentry_dsn" {
  type    = string
  default = ""
}

variable "enable_dhcp_cloudwatch_log_metrics" {
  type    = bool
  default = true
}

variable "metrics_namespace" {
  type    = string
  default = "Kea-DHCP"
}

variable "owner_email" {
  type    = string
  default = "lanwifi-devops@digital.justice.gov.uk"
}

variable "enable_rds_servers_bastion" {
  type    = bool
  default = false
}
