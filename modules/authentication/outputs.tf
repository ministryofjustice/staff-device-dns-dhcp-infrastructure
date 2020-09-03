output "cognito_user_pool_domain" {
  value = var.enable_authentication ? aws_cognito_user_pool_domain.main.*.domain : [""]
}

output "cognito_user_pool_id" {
  value = var.enable_authentication ? aws_cognito_user_pool.pool.*.id : [""]
}

output "cognito_user_pool_client_id" {
  value = var.enable_authentication ? aws_cognito_user_pool_client.client.*.id : [""]
}

output "cognito_user_pool_client_secret" {
  value     = var.enable_authentication ? aws_cognito_user_pool_client.client.*.client_secret : [""]
  sensitive = true
}
