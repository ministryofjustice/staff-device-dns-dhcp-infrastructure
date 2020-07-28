locals {
  domain = "https://${module.cognito.amazon-cognito-domain}.auth.${data.aws_region.current_region.id}.amazoncognito.com"
}
output "logoutUrl" {
  value = "\"${local.domain}/logout?response_type=code&client_id=${module.cognito.azure-client-id}&redirect_uri=https://localhost:80\""
}

output "url" {
  value = "\"${local.domain}/saml2/idpresponse\""
}

output "identifierUris" {
  value = "\"urn:amazon:cognito:sp:${module.cognito.cognito-pool-id}\""
}
