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
  default = false
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

variable "dhcp_transit_gateway_id" {
  type = string
}

variable "enable_dhcp_transit_gateway_attachment" {
  type    = bool
  default = false
}

variable "transit_gateway_route_table_id" {
  type = string
}

variable "dhcp_load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "dhcp_load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "dhcp_load_balancer_private_ip_eu_west_2c" {
  type = string
}

variable "dns_load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "dns_load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "dns_load_balancer_private_ip_eu_west_2c" {
  type = string
}

variable "enable_custom_domain_name" {
  type = bool
  default = false
}
