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

variable "vpc_id" {
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
  type = number
}

variable "max_capacity" {
  type = number
}

variable "min_capacity" {
  type = number
}

variable "load_balancer_config" {
  type = map
}

variable "has_api_service" {
  type = bool
}
