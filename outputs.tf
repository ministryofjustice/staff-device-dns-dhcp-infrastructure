output "terraform_outputs" {
  value = {
    dhcp = {
      ecs = module.dhcp.ecs
      ecr = module.dhcp.ecr
    }

    admin = {
      ecs = module.admin.ecs
    }

    authentication = {
      cognito = {
        identifier_urn = module.authentication.cognito_identifier_urn
        logout_url     = module.authentication.cognito_logout_url
        reply_url      = module.authentication.cognito_reply_url
      }
    }
  }
}
