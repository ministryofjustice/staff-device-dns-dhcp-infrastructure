variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "security_group_id" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "container_name" {
  type = string
}

variable "container_port" {
  type = string
}

variable "task_definition_arn" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2a" {
  type = string
}

variable "load_balancer_private_ip_eu_west_2b" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "critical_notifications_arn" {
  type = string
}

variable "has_api_lb" {
  type    = bool
  default = false
}

variable "api_lb_target_group_arn" {
  type    = string
  default = ""
}

variable "desired_count" {
  type    = number
}

variable "max_capacity" {
  type    = number
}

variable "min_capacity" {
  type    = number
}
