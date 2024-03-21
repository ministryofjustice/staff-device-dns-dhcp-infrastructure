variable "http_endpoint" {
  type = string
}
variable "prefix" {
  type = string
}
variable "access_key" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "cloudwatch_log_group_for_subscription" {
  type = string
}
