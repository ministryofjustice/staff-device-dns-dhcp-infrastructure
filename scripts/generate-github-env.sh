#!/usr/bin/env bash

## This script will export the params to the GITHUB_ENV
set -x

# run aws_ssm_get_parameters.sh
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SCRIPT_PATH="${SCRIPT_DIR}/aws_ssm_get_parameters.sh"
. "${SCRIPT_PATH}"

## This value has been applied to the envs via AWS CodePipeline CI.
## We don't want to use the default variable's value here.
echo "TF_VAR_owner_email=nac@justice.gov.uk" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
## There is no default value set in the variables.tf.
echo "TF_VAR_enable_authentication=true" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
echo "TF_VAR_enable_hosted_zone=true" >> $GITHUB_ENV

## This value has been applied to the envs via AWS CodePipeline CI.
echo "TF_VAR_enable_nac_transit_gateway_attachment=true" >> $GITHUB_ENV

for key in "${!parameters[@]}"
do
    ## uppercase key do not prefix with TF_VAR
    if [[ "${key}" =~ [A-Z] ]]; then
        echo "${key}=${parameters[${key}]}" >> $GITHUB_ENV
    else
        echo "TF_VAR_${key}=${parameters[${key}]}" >> $GITHUB_ENV
    fi
done
