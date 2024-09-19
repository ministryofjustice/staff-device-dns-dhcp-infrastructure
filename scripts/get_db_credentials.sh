#!/usr/bin/env bash

aws_secretsmanager_get_secret_value() {
 db_type=${1}

 if [ ${db_type} == "admin" ]; then
  aws secretsmanager get-secret-value \
        --secret-id /codebuild/dhcp/${ENV}/admin/db | jq --raw-output '.SecretString' | jq -r .password
 fi

 if [ ${db_type} == "server" ]; then
  aws secretsmanager get-secret-value \
        --secret-id /codebuild/dhcp/${ENV}/db | jq --raw-output '.SecretString' | jq -r .password
 fi
}

assume_role_in_environment() {
  export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
  $(aws sts assume-role \
  --role-arn "${TF_VAR_assume_role}" \
  --role-session-name MySessionName \
  --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
  --output text))
}

main() {
  assume_role_in_environment
  aws_secretsmanager_get_secret_value "${1}"
}

main "${1}"
