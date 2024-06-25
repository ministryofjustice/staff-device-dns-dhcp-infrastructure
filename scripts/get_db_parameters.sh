#!/usr/bin/env bash

export PARAM=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/codebuild/dhcp/$ENV/admin/db/username" \
    "/codebuild/dhcp/$ENV/admin/db/password" \
    --query Parameters)

export PARAM1=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/codebuild/dhcp/$ENV/db/username" \
    "/codebuild/dhcp/$ENV/db/password" \
    --query Parameters)

echo
echo $ENV
echo
#echo $PARAM
#echo $PARAM1

declare -A params

params["admin_db_password"]="$(echo $PARAM | jq '.[] | select(.Name | test("admin/db/password")) | .Value' --raw-output)"
params["admin_db_username"]="$(echo $PARAM | jq '.[] | select(.Name | test("admin/db/username")) | .Value' --raw-output)"
params["dhcp_db_password"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("db/password")) | .Value' --raw-output)"
params["dhcp_db_username"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("db/username")) | .Value' --raw-output)"



for key in "${!params[@]}"
do
  echo "${key}=${params[${key}]}"
done
