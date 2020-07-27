locals {
  domain = "https://${module.cognito.amazon-cognito-domain}.auth.${data.aws_region.current_region.id}.amazoncognito.com"
}

output "domain" {
  value = local.domain 
}

output "sign-in-url" {
  value = "${local.domain}/login?response_type=code&client_id=${module.cognito.azure-client-id}&redirect_uri=https://localhost:80"
}

output "sign-out-url" {
  value = "${local.domain}/logout?response_type=code&client_id=${module.cognito.azure-client-id}&redirect_uri=https://localhost:80"
}

output "reply-url" {
  value = "${local.domain}/saml2/idpresponse"
}

output "identifier-uri" {
  value = "urn:amazon:cognito:sp:${module.cognito.cognito-pool-id}"
}

