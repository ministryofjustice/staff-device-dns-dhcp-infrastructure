#!/usr/bin/env bash

## This script will export the params to the GITHUB_ENV
set -x

# run aws_ssm_get_parameters.sh
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SCRIPT_PATH="${SCRIPT_DIR}/aws_ssm_get_parameters.sh"
. "${SCRIPT_PATH}"

## This value has been applied to the envs via AWS CodePipeline CI.
## We don't want to use the default variable's value here.
echo "TF_VAR_enable_critical_notifications=true" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
## We don't want to use the default variable's value here.
echo "TF_VAR_enable_authentication=true" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
## We don't want to use the default variable's value here.
## (what about dev?)
echo "TF_VAR_admin_db_backup_retention_period=30" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
## We don't want to use the default variable's value here.
## (what about dev?)
echo "TF_VAR_enable_dhcp_transit_gateway_attachment=true" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
## it is not present in variables.tf (check)
echo "TF_VAR_enable_ssh_key_generation=false" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
## We don't want to use the default variable's value here.
echo "TF_VAR_enable_dhcp_cloudwatch_log_metrics=true" >> $GITHUB_ENV

for key in "${!params[@]}"
do
    ## uppercase key do not prefix with TF_VAR
    if [[ "${key}" =~ [A-Z] ]]; then
        echo "${key}=${params[${key}]}" >> $GITHUB_ENV
    else
        echo "TF_VAR_${key}=${params[${key}]}" >> $GITHUB_ENV
    fi
done
