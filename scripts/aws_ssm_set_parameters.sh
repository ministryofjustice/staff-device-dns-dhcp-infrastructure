#!/usr/bin/env bash

ENV="${1:-development}"
ENABLE_RDS_SERVERS_BASTION="${2:-false}"
ENABLE_RDS_ADMIN_BASTION="${3:-false}"
ENABLE_LOAD_TESTING="${4:-false}"

echo $ENV


### rds_servers_bastion
#aws ssm put-parameter \
#    --name "/staff-device/dns-dhcp/development/enable_rds_servers_bastion" \
#    --type "String" \
#    --value "$ENABLE_RDS_SERVERS_BASTION" \
#    --overwrite
#
### rds_admin_bastion
#aws ssm put-parameter \
#    --name "/staff-device/dns-dhcp/development/enable_rds_admin_bastion" \
#    --type "String" \
#    --value "$ENABLE_RDS_ADMIN_BASTION" \
#    --overwrite
#
#
### enable_load_testing
#aws ssm put-parameter \
#    --name "/staff-device/dns-dhcp/development/enable_load_testing" \
#    --type "String" \
#    --value "$ENABLE_LOAD_TESTING" \
#    --overwrite


export PARAM=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/staff-device/dns-dhcp/$ENV/enable_load_testing" \
    "/staff-device/dns-dhcp/$ENV/number_of_load_testing_nodes" \
    "/staff-device/dns-dhcp/$ENV/enable_rds_admin_bastion" \
    "/staff-device/dns-dhcp/$ENV/enable_rds_servers_bastion" \
    "/staff-device/dns-dhcp/$ENV/enable_bastion" \
    --query Parameters)

declare -A params

params["enable_load_testing"]="$(echo $PARAM | jq '.[] | select(.Name | test("enable_load_testing")) | .Value' --raw-output)"
params["number_of_load_testing_nodes"]="$(echo $PARAM | jq '.[] | select(.Name | test("number_of_load_testing_nodes")) | .Value' --raw-output)"
params["enable_rds_admin_bastion"]="$(echo $PARAM | jq '.[] | select(.Name | test("enable_rds_admin_bastion")) | .Value' --raw-output)"
params["enable_rds_servers_bastion"]="$(echo $PARAM | jq '.[] | select(.Name | test("enable_rds_servers_bastion")) | .Value' --raw-output)"
params["enable_corsham_test_bastion"]="$(echo $PARAM | jq '.[] | select(.Name | test("enable_bastion")) | .Value' --raw-output)"

for key in "${!params[@]}"
do
  echo "${key}=${params[${key}]}"
done
