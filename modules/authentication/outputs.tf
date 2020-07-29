output "azure-client-id" {
  value = aws_cognito_user_pool_client.client[0].id
}

output "amazon-cognito-domain" {
  value = aws_cognito_user_pool_domain.main[0].domain
}

output "cognito-pool-id" {
  value = aws_cognito_user_pool.pool[0].id
}
