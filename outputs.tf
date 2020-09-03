locals {
  domain = var.enable_authentication ? "https://${module.cognito.cognito_user_pool_domain}.auth.${data.aws_region.current_region.id}.amazoncognito.com" : ""
}

output "logoutUrl" {
  value = var.enable_authentication ? "\"${local.domain}/logout?response_type=code&client_id=${module.cognito.cognito_user_pool_client_id}&redirect_uri=http://localhost:80\"" : ""
}

output "url" {
  value = var.enable_authentication ? "\"${local.domain}/saml2/idpresponse\"" : ""
}

output "identifierUris" {
  value = var.enable_authentication ? "\"urn:amazon:cognito:sp:${module.cognito.cognito_user_pool_id}\"" : ""
}

output "cognito_user_pool_id" {
  value = var.enable_authentication ? module.cognito.cognito_user_pool_id[0] : ""
}

