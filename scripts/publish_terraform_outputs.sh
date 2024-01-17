#!/bin/bash

## publish terraform outputs

set -euo pipefail

terraform_outputs=$(terraform output -json terraform_outputs)

aws ssm put-parameter --name "/terraform_dns_dhcp/$ENV/outputs" \
  --description "Terraform outputs that other pipelines or processes depend on" \
  --value "$terraform_outputs" \
  --type String \
  --tier Intelligent-Tiering \
  --overwrite

dns_dhcp_vpc_id=$(terraform output --raw dns_dhcp_vpc_id)

aws ssm put-parameter --name "/staff-device/dns-dhcp/$ENV/vpc-id" \
  --description "VPC ID for Staff Device DNS DHCP" \
  --value $dns_dhcp_vpc_id \
  --type String \
  --overwrite
