variable "azure_federation_metadata_url" {
  type = string
}

variable "prefix" {
  type = string
}

variable "enable_authentication" {
  type = bool
}

variable "admin_url" {
  type = string
}

variable "region" {
  type = string
}

variable "vpn_hosted_zone_domain" {
  type = string
}

variable "tags" {
  type = map(string)
}
