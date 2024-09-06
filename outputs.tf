output "terraform_outputs" {
#   sensitive = true
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

output "dhcp_xsiam_s3_bucket" {
  value = module.kinesis_firehose_xsiam.xsiam_s3_bucket_name
}

output "rds_bastion" {
  value = {
    admin        = module.rds_admin_bastion[*].bastion
    server       = module.rds_servers_bastion[*].bastion
    load_testing = module.load_testing[*].bastion
  }
}
