locals {
  is_production = terraform.workspace == "production" ? true : false
}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace = "staff-device"
  stage     = terraform.workspace
  name      = var.service_name
  delimiter = "-"

  tags = {
    "business-unit" = "HQ"
    "application"   = "dhcp-dns",
    "is-production" = tostring(local.is_production)
    "owner"         = "NVVS DevOps Team:${var.owner_email}"

    "environment-name" = terraform.workspace
    "source-code"      = "https://github.com/ministryofjustice/staff-device-dns-dhcp-infrastructure"
  }
}
