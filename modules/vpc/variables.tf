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

variable "tags" {
  type = map(string)
}

variable "ssm_session_manager_endpoints" {
  type    = bool
  default = false
}

