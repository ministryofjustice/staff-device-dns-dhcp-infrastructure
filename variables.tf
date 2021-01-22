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

variable "azure_federation_metadata_url" {
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

variable "dns_load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "dns_load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "dhcp_api_load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "dhcp_api_load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "enable_corsham_test_bastion" {
  type    = bool
  default = true
}

variable "admin_local_development_domain_affix" {
  type    = string
  default = ""
}

variable "sentry_dsn" {
  type    = string
  default = ""
}

variable "bastion_allowed_ingress_ip" {
  type    = string
  default = "noop"
}

variable "bastion_allowed_egress_ip" {
  type    = string
  default = "noop"
}

variable "pdns_ips" {
  type = string
}

variable "pdns_ips_list" {
  type = list(string)
}

variable "dhcp_egress_transit_gateway_routes" {
  type = set(string)
}

variable "corsham_vm_ip" {
  type = string
}

variable "byoip_pool_id" {
  type = string
}

variable "enable_dhcp_cloudwatch_log_metrics" {
  type    = bool
  default = false
}
