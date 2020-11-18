variable "prefix" {
  type = string
}

variable "subnets" {
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

variable "service_ip" {
  type = string
}

variable "short_prefix" {
  type = string
}

variable "dhcp_db_name" {
  type = string
}

variable "dhcp_db_host" {
  type = string
}

variable "dhcp_db_port" {
  type = string
}

variable "kea_config_bucket_name" {
  type = string
}

variable "dhcp_config_bucket_key_arn" {
  type = string
}

variable "dhcp_repository_url" {
  type = string
}

variable "server_log_group_name" {
  type = string
}

variable "container_port" {
  type    = string
  default = 67
}

variable "container_name" {
  type    = string
  default = "dhcp-server"
}
