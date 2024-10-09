#!make
.DEFAULT_GOAL := help
SHELL := '/bin/bash'

CURRENT_TIME := `date "+%Y.%m.%d-%H.%M.%S"`
TERRAFORM_VERSION := `cat versions.tf 2> /dev/null | grep required_version | cut -d "\\"" -f 2 | cut -d " " -f 2`

LOCAL_IMAGE := ministryofjustice/nvvs/terraforms:latest
DOCKER_IMAGE := ghcr.io/ministryofjustice/nvvs/terraforms:latest

DOCKER_RUN := @docker run --rm \
				--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
				--env-file <(env | grep ^TF_VAR_) \
				--env-file <(env | grep ^ENV) \
				-e TFENV_TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
				-v `pwd`:/data \
				--workdir /data \
				--platform linux/amd64 \
				$(DOCKER_IMAGE)

DOCKER_RUN_IT := @docker run --rm -it \
				--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
				--env-file <(env | grep ^TF_VAR_) \
				--env-file <(env | grep ^ENV) \
				-e TFENV_TERRAFORM_VERSION=$(TERRAFORM_VERSION) \
				-v `pwd`:/data \
				--workdir /data \
				--platform linux/amd64 \
				$(DOCKER_IMAGE)

export DOCKER_DEFAULT_PLATFORM=linux/amd64

.PHONY: debug
debug:  ## debug
	@echo "debug"
	$(info target is $@)

.PHONY: aws
aws:  ## provide aws cli command as an arg e.g. (make aws AWSCLI_ARGUMENT="s3 ls")
	$(DOCKER_RUN) /bin/bash -c "aws $$AWSCLI_ARGUMENT"

.PHONY: shell
shell: ## Run Docker container with interactive terminal
	$(DOCKER_RUN_IT) /bin/bash

.PHONY: fmt
fmt: ## terraform fmt
	$(DOCKER_RUN) terraform fmt --recursive

.PHONY: init
init: ## terraform init (make init ENV_ARGUMENT=pre-production) NOTE: Will also select the env's workspace.

## INFO: Do not indent the conditional below, make stops with an error.
ifneq ("$(wildcard .env)","")
$(info Using config file ".env")
include .env
init: -init
else
$(info Config file ".env" does not exist.)
init: -init-gen-env
endif

.PHONY: -init-gen-env
-init-gen-env:
	$(MAKE) gen-env
	$(MAKE) -init

.PHONY: -init
-init:
	$(DOCKER_RUN) terraform init --backend-config="key=terraform.$$ENV.state"
	$(MAKE) workspace-select

.PHONY: init-upgrade
init-upgrade: ## terraform init -upgrade
	$(DOCKER_RUN) terraform init -upgrade --backend-config="key=terraform.$$ENV.state"

.PHONY: import
import: ## terraform import e.g. (make import IMPORT_ARGUMENT="module.foo.bar some_resource")
	$(DOCKER_RUN) terraform import $$IMPORT_ARGUMENT

.PHONY: rm
rm: ## terraform import e.g. (make rm RM_ARGUMENT="module.foo.bar")
	$(DOCKER_RUN) terraform state rm $$RM_ARGUMENT

.PHONY: workspace-list
workspace-list: ## terraform workspace list
	$(DOCKER_RUN) terraform workspace list

.PHONY: workspace-select
workspace-select: ## terraform workspace select
	$(DOCKER_RUN) terraform workspace select $$ENV || \
	$(DOCKER_RUN) terraform workspace new $$ENV

.PHONY: validate
validate: ## terraform validate
	$(DOCKER_RUN) terraform validate

.PHONY: plan-out
plan-out: ## terraform plan - output to timestamped file
	$(DOCKER_RUN) terraform plan -no-color > $$ENV.$(CURRENT_TIME).tfplan

.PHONY: plan
plan: ## terraform plan
	$(DOCKER_RUN) terraform plan

.PHONY: refresh
refresh: ## terraform refresh
	$(DOCKER_RUN) terraform refresh

.PHONY: console
console: ## terraform refresh
	$(DOCKER_RUN) terraform console
	

.PHONY: output
output: ## terraform output (make output OUTPUT_ARGUMENT='--raw dns_dhcp_vpc_id')
	$(DOCKER_RUN) terraform output -no-color $$OUTPUT_ARGUMENT

#.PHONY: output-bastion-rds-admin
#output-bastion-rds-admin: ## terraform output (make output-bastion-rds-admin)
#	$(DOCKER_RUN) /bin/bash -c "./scripts/get_db_parameters.sh"
.PHONY: rds-admin
rds-admin: ## Get RDS admin connection details (make rds-admin)
	$(DOCKER_RUN) /bin/bash -c "./scripts/create_db_connection_details.sh admin"

.PHONY: rds-server
rds-server: ## Get RDS server connection details (make rds-server)
	$(DOCKER_RUN) /bin/bash -c "./scripts/create_db_connection_details.sh server"

.PHONY: rds-admin-password
rds-admin-password: ## Get RDS admin password (make rds-admin-password)
	$(DOCKER_RUN) /bin/bash -c "./scripts/get_db_credentials.sh admin"

.PHONY: rds-server-password
rds-server-password: ## Get RDS server password (make rds-server-password)
	$(DOCKER_RUN) /bin/bash -c "./scripts/get_db_credentials.sh server"

.PHONY: instanceid-bastion-rds-admin
instanceid-bastion-rds-admin: ## Get RDS Admin bastion Instance ID (make instanceid-bastion-rds-admin)
	$(DOCKER_RUN) /bin/bash -c "terraform output -no-color -json rds_bastion | jq -r .admin[][]"

.PHONY: instanceid-bastion-rds-server
instanceid-bastion-rds-server: ## Get RDS server bastion Instance ID (make instanceid-bastion-rds-server)
	$(DOCKER_RUN) /bin/bash -c "terraform output -no-color -json rds_bastion | jq -r .server[][]"

.PHONY: instanceid-bastion-rds-load_testing
instanceid-bastion-rds-load_testing: ## Get load testing bastion Instance ID  (make instanceid-bastion-rds-load_testing)
	$(DOCKER_RUN) /bin/bash -c "terraform output -no-color -json rds_bastion | jq -r .load_testing[][]"

.PHONY: apply
apply: ## terraform apply
	$(DOCKER_RUN_IT) terraform apply
	$(DOCKER_RUN) /bin/bash -c "./scripts/publish_terraform_outputs.sh"

.PHONY: state-list
state-list: ## terraform state list
	$(DOCKER_RUN) terraform state list

.PHONY: show
show: ## terraform show
	$(DOCKER_RUN) terraform show -no-color

.PHONY: destroy
destroy: ## terraform destroy
	$(DOCKER_RUN) terraform destroy

.PHONY: lock
lock: ## terraform providers lock (reset hashes after upgrades prior to commit)
	rm .terraform.lock.hcl
	$(DOCKER_RUN) terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64

.PHONY: clean
clean: ## clean terraform cached providers etc
	rm -rf .terraform/ terraform.tfstate* .env

.PHONY: gen-env
gen-env: ## generate a ".env" file with the correct TF_VARS for the environment e.g. (make gen-env ENV_ARGUMENT=pre-production)
	$(DOCKER_RUN) /bin/bash -c "./scripts/generate-env-file.sh $$ENV_ARGUMENT"

.PHONY: aws_describe_instances
aws_describe_instances: ## Use AWS CLI to describe EC2 instances - outputs a table with instance id, type, IP and name for current environment
	$(DOCKER_RUN) /bin/bash -c "./scripts/aws_describe_instances.sh"

.PHONY: aws_ssm_start_session
aws_ssm_start_session: ## Use AWS CLI to start SSM session on an EC2 instance (make aws_ssm_start_session INSTANCE_ID=i-01d4de517c7336ff3)
	$(DOCKER_RUN_IT) /bin/bash -c "./scripts/aws_ssm_start_session.sh $$INSTANCE_ID"

.PHONY: tfenv
tfenv: ## tfenv pin - terraform version from versions.tf
	tfenv use $(cat versions.tf 2> /dev/null | grep required_version | cut -d "\"" -f 2 | cut -d " " -f 2) && tfenv pin

.PHONY: target
target: ## terraform target
	$(DOCKER_RUN) terraform plan -target='module.rds_admin_bastion[0].aws_iam_role.iam_instance_role'

help:
	@grep -h -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
