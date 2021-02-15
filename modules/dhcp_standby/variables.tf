variable "prefix" {
  type = string
}

variable "short_prefix" {
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

variable "nginx_repository_url" {
  type = string
}

variable "dhcp_repository_url" {
  type = string
}

variable "dhcp_db_host" {
  type = string
}

variable "dhcp_server_db_name" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "dhcp_server_cluster_id" {
  type = string
}

variable "container_port" {
  type    = string
  default = "67"
}

variable "container_name" {
  type    = string
  default = "dhcp-server"
}

variable "kea_config_bucket_name" {
  type = string
}

variable "dhcp_server_security_group_id" {
  type = string
}

variable "metrics_namespace" {
  type = string
}

variable "dhcp_log_search_metric_filters" {
  type = set(string)
}
