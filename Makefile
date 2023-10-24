#!make
SHELL := '/bin/bash'

CURRENT_TIME := `date "+%Y.%m.%d-%H.%M.%S"`
TERRAFORM_VERSION := `cat versions.tf 2> /dev/null | grep required_version | cut -d "\\"" -f 2 | cut -d " " -f 2`

#BUILD_TOOLS_DOCKER_IMAGE := ghcr.io/ministryofjustice/nvvs/terraform:initial-setup terraform
BUILD_TOOLS_DOCKER_IMAGE := hashicorp/terraform:$(TERRAFORM_VERSION)

DOCKER_RUN := @docker run --rm \
				--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
				--env-file <(env | grep ^TF_VAR_) \
				-v `pwd`:/data \
				--workdir /data \
				--platform linux/amd64 \
				$(BUILD_TOOLS_DOCKER_IMAGE)

export DOCKER_DEFAULT_PLATFORM=linux/amd64
include .env


fmt:
	$(DOCKER_RUN) fmt --recursive

init:
	$(DOCKER_RUN) init --backend-config="key=terraform.$$ENV.state"

init-upgrade:
	$(DOCKER_RUN) init -upgrade --backend-config="key=terraform.$$ENV.state"

# How to use
# IMPORT_ARGUMENT=module.foo.bar some_resource make import
import:
	$(DOCKER_RUN) import $$IMPORT_ARGUMENT

workspace-list:
	$(DOCKER_RUN) workspace list

workspace-select:
	$(DOCKER_RUN) workspace select $$ENV || \
	$(DOCKER_RUN) workspace new $$ENV

validate:
	$(DOCKER_RUN) validate

plan-out:
	$(DOCKER_RUN) plan -no-color > $$ENV.$(CURRENT_TIME).tfplan

plan:
	$(DOCKER_RUN) plan

refresh:
	$(DOCKER_RUN) refresh

output:
	$(DOCKER_RUN) output -json

apply:
	$(DOCKER_RUN) apply
	./scripts/publish_terraform_outputs.sh

state-list:
	$(DOCKER_RUN) state list

show:
	$(DOCKER_RUN) show -no-color

destroy:
	$(DOCKER_RUN) destroy

lock:
	rm .terraform.lock.hcl
	$(DOCKER_RUN) providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64

clean:
	rm -rf .terraform/ terraform.tfstate*

tfenv:
	tfenv use $(cat versions.tf 2> /dev/null | grep required_version | cut -d "\"" -f 2 | cut -d " " -f 2) && tfenv pin

.PHONY:
	fmt init workspace-list workspace-select validate plan-out plan \
	refresh output apply state-list show destroy lock clean tfenv
