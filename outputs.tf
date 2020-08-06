locals {
  domain = var.enable_authentication ? "https://${module.cognito.amazon-cognito-domain[0]}.auth.${data.aws_region.current_region.id}.amazoncognito.com" : ""
}

output "logoutUrl" {
  value = var.enable_authentication ? "\"${local.domain}/logout?response_type=code&client_id=${module.cognito.azure-client-id[0]}&redirect_uri=http://localhost:80\"" : ""
}

output "url" {
  value = var.enable_authentication ? "\"${local.domain}/saml2/idpresponse\"" : ""
}

output "identifierUris" {
  value = var.enable_authentication ? "\"urn:amazon:cognito:sp:${module.cognito.cognito-pool-id[0]}\"" : ""
}
