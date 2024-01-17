output "terraform_outputs" {
  value = {
    dhcp = {
      ecs = module.dhcp.ecs
      ecr = module.dhcp.ecr
      db  = module.dhcp.db
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

    servers = {
      vpc = module.servers_vpc.vpc_brief
    }

    admin = {
      ecs = module.admin.ecs
      ecr = module.admin.ecr
      db  = module.admin.db
      vpc = module.admin_vpc.vpc_brief
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

output "dns_dhcp_vpc_id" {
  value = module.servers_vpc.vpc_id
}
