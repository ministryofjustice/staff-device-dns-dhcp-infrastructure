variable "cidr_block" {
  type = string
}

variable "cidr_block_new_bits" {
  type    = number
  default = 8
}

variable "region" {
  type = string
}

variable "prefix" {
  type = string
}

variable "enable_dhcp_transit_gateway_attachment" {
  type = bool
}

variable "byoip_pool_id" {
  type = string
}

variable "pdns_ips" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "dhcp_transit_gateway_id" {
  type = string
}

variable "transit_gateway_route_table_id" {
  type = string
}

variable "corsham_vm_ip" {
  type = string
}

variable "model_office_vm_ip" {
  type = string
}
