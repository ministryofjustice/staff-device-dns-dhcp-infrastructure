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

variable "load_balancer_private_ip_eu_west_2c" {
  type = string
}

variable "vpc_id" {
  type = string
}

<<<<<<< HEAD
variable "critical_notifications_arn" {
=======
variable "critical_notifications_arn"{
>>>>>>> fde049d... renamed alarms for clarity
  type = string
}
