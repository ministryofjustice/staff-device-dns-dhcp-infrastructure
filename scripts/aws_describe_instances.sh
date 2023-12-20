#!/usr/bin/env bash

## Script to describe ec2 instances in target environment

aws_describe_instances() {
	aws \
	ec2 describe-instances \
	--query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' \
	--output table
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
  aws_describe_instances
}

main
