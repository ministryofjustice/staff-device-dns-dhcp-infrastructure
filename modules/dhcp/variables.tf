variable "prefix" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "vpc_id" {
  type = string
}

variable "dhcp_db_username" {
  type = string
}

variable "dhcp_db_password" {
  type = string
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}

variable "dhcp_transit_gateway_id" {
  type = string
}

variable "enable_dhcp_transit_gateway_attachment" {
  type = bool
}

variable "transit_gateway_route_table_id" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2c" {
  type = string
}

variable "enable_ssh_key_generation" {
  type = bool
}
