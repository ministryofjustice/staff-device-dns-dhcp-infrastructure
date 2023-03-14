terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.76.1"
    }
  }
}

locals {
  enabled = var.enable_authentication ? 1 : 0
}

resource "aws_cognito_user_pool" "pool" {
  count                    = local.enabled
  name                     = "${var.prefix}_azure_ad_pool"
  auto_verified_attributes = ["email"]
  tags                     = var.tags

  schema {
    name                = "app_role"
    attribute_data_type = "String"
    mutable             = true

    string_attribute_constraints {
      min_length = 1
      max_length = 255
    }
  }
}

resource "aws_cognito_user_pool_client" "client" {
  count                                = local.enabled
  name                                 = "${var.prefix}_azure_ad_client"
  user_pool_id                         = aws_cognito_user_pool.pool[0].id
  explicit_auth_flows                  = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  callback_urls                        = ["https://${var.admin_url}/users/auth/cognito/callback"]
  logout_urls                          = ["https://${var.admin_url}"]
  supported_identity_providers         = [aws_cognito_identity_provider.cognito_identity_provider[0].provider_name]
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_scopes                 = ["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"]
  generate_secret                      = true
}

resource "aws_cognito_user_pool_domain" "main" {
  count = local.enabled
  # domain names can't have underscores
  domain       = "${replace(var.vpn_hosted_zone_domain, ".", "-")}-auth"
  user_pool_id = aws_cognito_user_pool.pool[0].id
}

resource "aws_cognito_identity_provider" "cognito_identity_provider" {
  count         = local.enabled
  user_pool_id  = aws_cognito_user_pool.pool[0].id
  provider_name = "Azure"
  provider_type = "SAML"

  provider_details = {
    MetadataURL           = var.azure_federation_metadata_url
    SLORedirectBindingURI = replace(var.azure_federation_metadata_url, "federationmetadata/2007-06/federationmetadata.xml", "saml2")
    SSORedirectBindingURI = replace(var.azure_federation_metadata_url, "federationmetadata/2007-06/federationmetadata.xml", "saml2")
  }

  attribute_mapping = {
    email             = "email"
    "custom:app_role" = "https://aws.amazon.com/SAML/Attributes/Role"
  }
}
