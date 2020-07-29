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

variable "enable_authentication"{
  type = bool
  default = false
}
