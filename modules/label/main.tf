module "label" {
  source  = "cloudposse/label/null"
  version = "0.19.2"

  namespace = "staff-device"
  stage     = terraform.workspace
  name      = var.service_name
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "dns-dhcp",
    "is-production" = "true"
    "owner"         = "staff-device-dns-dhcp@digital.justice.gov.uk"

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-device-dns-dhcp-infrastructure"
  }
}
