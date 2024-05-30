variable "prefix" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "dhcp_db_username" {
  type = string
}

variable "dhcp_db_password" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "vpn_hosted_zone_id" {
  type = string
}

variable "vpn_hosted_zone_domain" {
  type = string
}

variable "short_prefix" {
  type = string
}

variable "admin_local_development_domain_affix" {
  type = string
}

variable "metrics_namespace" {
  type = string
}

variable "dhcp_log_search_metric_filters" {
  type = set(string)
}

variable "sentry_dsn" {
  type = string
}

variable "shared_services_account_id" {
  type = string
}
