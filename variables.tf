variable "assume_role" {
  type = string
}

#variable "dhcp_db_username" {
#  type = string
#}

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
  type    = list(any)
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

variable "model_office_vm_ip" {
  type = string
}

variable "byoip_pool_id" {
  type = string
}

variable "enable_dhcp_cloudwatch_log_metrics" {
  type    = bool
  default = false
}

variable "metrics_namespace" {
  type    = string
  default = "Kea-DHCP"
}

variable "dns_route53_resolver_ip_eu_west_2a" {
  type = string
}

variable "dns_route53_resolver_ip_eu_west_2b" {
  type = string
}

variable "dns_private_zone" {
  type = string
}

variable "allowed_ip_ranges" {
  type = list(string)
}

variable "api_basic_auth_username" {
  type        = string
  description = "http basic auth username for the dhcp-stats api endpoint"
}

variable "api_basic_auth_password" {
  type        = string
  description = "http basic auth password for the dhcp-stats api endpoint"
}

variable "shared_services_account_id" {
  type = string
}

variable "owner_email" {
  type    = string
  default = "lanwifi-devops@digital.justice.gov.uk"
}

variable "enable_load_testing" {
  type    = bool
  default = false
}

variable "number_of_load_testing_nodes" {
  type = number
}

variable "enable_rds_admin_bastion" {
  type    = bool
  default = false
}

variable "enable_rds_servers_bastion" {
  type    = bool
  default = false
}
