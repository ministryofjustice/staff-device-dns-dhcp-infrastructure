#!/bin/bash

set -eo pipefail

if [[ "${PLAN}" == "true" ]]; then
  terraform plan -no-color
else
  terraform apply --auto-approve -no-color
fi
