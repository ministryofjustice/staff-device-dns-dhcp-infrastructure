output "azure-client-id" {
  value = aws_cognito_user_pool_client.client.*.id
}

output "amazon-cognito-domain" {
  value = aws_cognito_user_pool_domain.main.*.domain
}

output "cognito-pool-id" {
  value = aws_cognito_user_pool.pool.*.id
}
