variable "is_production" {
  type    = string
  default = true
}

variable "owner_email" {
  type    = string
  default = "staff-device-dns-dhcp@digital.justice.gov.uk"
}

variable "assume_role" {
  type = string
}

variable "dhcp_db_username" {
  type = string
}

variable "dhcp_db_password" {
  type = string
}

variable "env" {
  type = string
}

variable "meta_data_url" {
  type = string
}

variable "enable_authentication" {
  type    = bool
  default = true
}

variable "enable_critical_notifications" {
  type    = bool
  default = false
}

variable "critical_notification_recipients" {
  type    = list
  default = []
}

variable "admin_db_username" {
  type = string
}

variable "admin_db_password" {
  type = string
}

variable "vpn_hosted_zone_id" {
  type = string
}

variable "vpn_hosted_zone_domain" {
  type = string
}

variable "admin_db_backup_retention_period" {
  type    = number
  default = 0
}
