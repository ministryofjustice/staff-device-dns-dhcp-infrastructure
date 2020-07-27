resource "aws_cognito_user_pool" "pool" {
  name = "azure-ad-pool"
}

resource "aws_cognito_user_pool_client" "client" {
  name = "azure-ad-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  supported_identity_providers = [aws_cognito_identity_provider.cognito_identity_provider.provider_name]

  callback_urls = ["https://localhost:4200"]
  logout_urls = ["https://localhost:4200"]
}

resource "aws_cognito_user_pool_domain" "main" {
  domain       = "azure-ad-authentication"
  user_pool_id = aws_cognito_user_pool.pool.id
}

resource "aws_cognito_identity_provider" "cognito_identity_provider" {
  user_pool_id  = aws_cognito_user_pool.pool.id
  provider_name = "Azure"
  provider_type = "SAML"

  provider_details = {
    MetadataURL            = var.meta_data_url
  }

  attribute_mapping = {
    email = "email"
  }
}
