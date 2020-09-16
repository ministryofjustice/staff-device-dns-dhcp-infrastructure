locals {
  subdomain = var.enable_authentication ? aws_cognito_user_pool_domain.main.*.domain[0] : ""
  domain    = var.enable_authentication ? "https://${local.subdomain}.auth.${var.region}.amazoncognito.com" : ""
  pool_id   = var.enable_authentication ? aws_cognito_user_pool.pool.*.id[0] : ""
  client_id = var.enable_authentication ? aws_cognito_user_pool_client.client.*.id[0] : ""
}

output "cognito_user_pool_domain" {
  value = local.subdomain
}

output "cognito_user_pool_id" {
  value = local.pool_id
}

output "cognito_user_pool_client_id" {
  value = local.client_id
}

output "cognito_user_pool_client_secret" {
  value     = var.enable_authentication ? aws_cognito_user_pool_client.client.*.client_secret[0] : ""
  sensitive = true
}

# These outputs are used for manual azure configuration
output "cognito_identifier_urn" {
  value = var.enable_authentication ? "urn:amazon:cognito:sp:${local.pool_id}" : ""
}

output "cognito_reply_url" {
  value = var.enable_authentication ? "${local.domain}/saml2/idpresponse" : ""
}

output "cognito_logout_url" {
  value = var.enable_authentication ? "${local.domain}/logout?response_type=code&client_id=${local.client_id}&redirect_uri=http://localhost:80" : ""
}
