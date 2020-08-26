output "cognito_user_pool_domain" {
  value = aws_cognito_user_pool_domain.main[0].domain
}

output "cognito_user_pool_id" {
  value = aws_cognito_user_pool.pool[0].id
}

output "cognito_user_pool_client_id" {
  value = aws_cognito_user_pool_client.client[0].id
}

output "cognito_user_pool_client_secret" {
  value     = aws_cognito_user_pool_client.client[0].client_secret
  sensitive = true
}
