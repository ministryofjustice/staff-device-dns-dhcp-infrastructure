resource "aws_cognito_user_pool" "pool" {
  name = "azure-ad-pool"
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name = "azure-ad-client"
  user_pool_id = aws_cognito_user_pool.pool.id
  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  callback_urls = ["http://localhost:80"]
  logout_urls = ["http://localhost:80"]
  supported_identity_providers = [aws_cognito_identity_provider.cognito_identity_provider.provider_name]
  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
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
