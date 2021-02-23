variable "prefix" {
  type = string
}

variable "short_prefix" {
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

variable "load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "sentry_dsn" {
  type = string
}
