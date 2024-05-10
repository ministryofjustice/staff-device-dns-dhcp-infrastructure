#!/usr/bin/env bash

set -x

aws_describe_instances() {
  local instanceId="$1"
	aws \
	ec2 describe-instances \
	--query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,State.Name,Tags[?Key==`Name`]| [0].Value]' \
	--instance-ids "${instanceId}" \
	--output text
}

instances=""

input="prod-ec2-publicip.txt"
######################################
# $IFS removed to allow the trimming #
#####################################
while read -r line
do
  echo "$line"
  aws_describe_instances "$line" >> instances.txt
done < "$input"

cat instances.txt
