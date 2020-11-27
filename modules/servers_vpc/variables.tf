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

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "rds_endpoint_private_dns_enabled" {
  type    = bool
  default = false
}

variable "enable_s3_endpoint" {
  type    = bool
  default = false
}
