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
    "is-production" = "true"
    "owner"         = "NVVS DevOps Team https://ministryofjustice.github.io/nvvs-devops"

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-dns-dhcp-infrastructure"
  }
}
