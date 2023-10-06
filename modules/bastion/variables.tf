variable "vpc_id" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "private_subnets" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}

variable "prefix" {
  type = string
}

# variable "bastion_allowed_ingress_ip" {
#   type = string
# }
variable "name" {
  type        = string
  description = "The name to be interpolated, defaults to bastion-ssm-iam"
  default     = "bastion-ssm-iam"
}

variable "log_retention" {
  type        = number
  description = "The amount of days the logs need to be kept"
  default     = 30
}

variable "number_of_bastions" {
  type    = number
  default = 1
}
