#!/usr/bin/env bash

## This script will generate .env file for use with the Makefile
## or to export the TF_VARS into the environment

set -x

export ENV="${1:-development}"

printf "\n\nEnvironment is %s\n\n" "${ENV}"

case "${ENV}" in
    development)
        echo "development -- Continuing..."
        ;;
    pre-production)
        echo "pre-production -- Continuing..."
        ;;
    production)
        echo "production shouldn't be running this locally. Exiting..."
        exit 1
        ;;
    *)
        echo "Invalid input."
        ;;
esac

echo "Press 'y' to continue or 'n' to exit."

# Wait for the user to press a key
read -s -n 1 key

# Check which key was pressed
case $key in
    y|Y)
        echo "You pressed 'y'. Continuing..."
        ;;
    n|N)
        echo "You pressed 'n'. Exiting..."
        exit 1
        ;;
    *)
        echo "Invalid input. Please press 'y' or 'n'."
        ;;
esac

# run aws_ssm_get_parameters.sh
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
SCRIPT_PATH="${SCRIPT_DIR}/aws_ssm_get_parameters.sh"
. "${SCRIPT_PATH}"


cat << EOF > ./.env
# env file
# regenerate by running "./scripts/generate-env-file.sh"
# defaults to "development"
# To test against another environment
# regenerate by running "./scripts/generate-env-file.sh [pre-production | production]"
# Also run "make clean"
# then run "make init"


export AWS_PROFILE=mojo-shared-services-cli
export AWS_VAULT_PROFILE=mojo-shared-services-cli

### ${ENV} ###
export ENV=${ENV}


## buildspec defaults

## We do not want to disable prompt for local builds.
## https://developer.hashicorp.com/terraform/cli/config/environment-variables#tf_input
##TF_INPUT: 0 ## We wnat this locally to ensure we have provided all

## This value has been applied to the envs via AWS CodePipeline CI.
## We don't want to use the default variable's value here.
export TF_VAR_owner_email=nac@justice.gov.uk

## This value has been applied to the envs via AWS CodePipeline CI.
## There is no default value set in the variables.tf.
export TF_VAR_enable_authentication=true

## This value has been applied to the envs via AWS CodePipeline CI.
export TF_VAR_enable_hosted_zone=true

## This value has been applied to the envs via AWS CodePipeline CI.
export TF_VAR_enable_nac_transit_gateway_attachment=true

EOF

for key in "${!parameters[@]}"
do
    ## uppercase key do not prefix with TF_VAR
    if [[ "${key}" =~ [A-Z] ]]; then
        echo "export ${key}=${parameters[${key}]}"  >> ./.env
    else
        echo "export TF_VAR_${key}=${parameters[${key}]}"  >> ./.env
    fi
done

chmod u+x ./.env

rm -rf .terraform/ terraform.tfstate*

printf "\n\n run \"make init\"\n\n"
