#!/bin/bash

set -e

log_group_names=$(aws logs describe-log-groups | jq -r '.logGroups | .[] | .logGroupName')
retention_period=7

for log_group_name in $log_group_names
do
  echo "setting log retention policy for $log_group_name to $retention_period days"
  aws logs put-retention-policy --log-group-name $log_group_name --retention-in-days $retention_period
done
