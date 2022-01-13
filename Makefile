#!make
include .env
export

aws-vault-command := aws-vault exec $$AWS_VAULT_PROFILE --backend=$$BACKEND --prompt=$$PROMPT

fmt:
	terraform fmt --recursive

init:
	$(aws-vault-command) -- terraform init -reconfigure \
	--backend-config="key=terraform.development.state"

validate:
	$(aws-vault-command) -- terraform validate

plan:
	$(aws-vault-command) -- terraform plan -out terraform.tfplan

apply:
	$(aws-vault-command) --duration=2h -- terraform apply
	$(aws-vault-command) -- ./scripts/publish_terraform_outputs.sh

destroy:
	$(aws-vault-command) --duration=2h -- terraform destroy

.PHONY: fmt init validate plan apply destroy
