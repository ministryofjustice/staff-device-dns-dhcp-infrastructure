output "terraform_outputs" {
  value = {
    dhcp = {
      ecs = module.dhcp.ecs
      ecr = module.dhcp.ecr
    }

    dhcp_standby = {
      ecs = module.dhcp_standby.ecs
    }

    dhcp_api = {
      ecs = module.dhcp.ecs_dhcp_api
    }

    dns = {
      ecs = module.dns.ecs
      ecr = module.dns.ecr
    }

    admin = {
      ecs = module.admin.ecs
      ecr = module.admin.ecr
    }

    heartbeat = {
      dhcp = module.heartbeat.cloudwatch
    }

    metrics_namespace = var.metrics_namespace

    authentication = {
      cognito = {
        identifier_urn = module.authentication.cognito_identifier_urn
        logout_url     = module.authentication.cognito_logout_url
        reply_url      = module.authentication.cognito_reply_url
      }
    }
  }
}
