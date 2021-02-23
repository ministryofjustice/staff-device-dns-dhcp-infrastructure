variable "tags" {
  type = map(string)
}

variable "subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "prefix" {
  type = string
}

variable "dhcp_ip" {
  type = string
}

variable "metrics_namespace" {
  type = string
}

variable "hearbeat_instance_private_static_ip" {
  type = string
}
