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
<<<<<<< HEAD
=======

variable "dhcp_db_username" {
  type = string
}

variable "dhcp_db_password" {
  type = string
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
}
>>>>>>> main
