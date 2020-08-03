variable "dhcp_cluster_name"{
  type = string
}

variable "prefix" {
  type = string
}

variable "enable_critical_notifications"{
  type = bool
}

variable "topic_name"{
  type = string
}

variable "critical_notification_recipients" {
  type    = list
}

variable "rds_identifier" {
  type = string
}

variable "load_balancer" {
  type = string
}
