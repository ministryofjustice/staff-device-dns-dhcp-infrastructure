#!make
SHELL := '/usr/local/opt/bash/bin/bash'
export DOCKER_DEFAULT_PLATFORM=linux/amd64
include .env
export

fmt:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform fmt --recursive

init:
	docker run --rm -it \
	-v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker \
	-v $$(pwd):/data -w /data \
	--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
	--env-file <(env | grep ^TF_VAR_) \
	hashicorp/terraform:1.1.8 \
	init -reconfigure \
	--backend-config="key=terraform.$$ENV.state"

	# aws-vault exec $$AWS_VAULT_PROFILE -- terraform init -reconfigure \
	# --backend-config="key=terraform.$$ENV.state"

init-upgrade:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform init -upgrade \
	--backend-config="key=terraform.$$ENV.state"

workspace-list:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform workspace list

workspace-select:
	docker run --rm -it \
	-v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker \
	-v $$(pwd):/data -w /data \
	--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
	--env-file <(env | grep ^TF_VAR_) \
	hashicorp/terraform:1.1.8 \
	workspace select $$ENV

	# aws-vault exec $$AWS_VAULT_PROFILE -- terraform workspace select $$ENV || \
	# aws-vault exec $$AWS_VAULT_PROFILE -- terraform workspace new $$ENV

validate:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform validate

plan-out:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform plan -no-color > $$ENV.tfplan

plan:
	docker run --rm -it \
	-v /var/run/docker.sock:/var/run/docker.sock -v /var/lib/docker:/var/lib/docker \
	-v $$(pwd):/data -w /data \
	--env-file <(aws-vault exec $$AWS_PROFILE -- env | grep ^AWS_) \
	--env-file <(env | grep ^TF_VAR_) \
	hashicorp/terraform:1.1.8 \
	plan
	#aws-vault exec $$AWS_VAULT_PROFILE -- terraform plan

refresh:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform refresh

output:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform output -json

apply:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform apply
	./scripts/publish_terraform_outputs.sh

state-list:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform state list

show:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform show -no-color

destroy:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform destroy

lock:
	rm .terraform.lock.hcl
	terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64

clean:
	rm -rf .terraform/ terraform.tfstate*

tfenv:
	tfenv use $(cat versions.tf 2> /dev/null | grep required_version | cut -d "\"" -f 2 | cut -d " " -f 2) && tfenv pin

.PHONY:
	fmt init workspace-list workspace-select validate plan-out plan \
	refresh output apply state-list show destroy lock clean tfenv
