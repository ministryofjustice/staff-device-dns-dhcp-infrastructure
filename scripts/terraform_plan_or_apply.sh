#!/bin/bash

set -eo pipefail

if [[ "${PLAN}" == "true" ]]; then
  terraform plan
else
  terraform apply --auto-approve -no-color
fi
