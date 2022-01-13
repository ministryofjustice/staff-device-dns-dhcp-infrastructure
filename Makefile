#!make
include .env
export

ifdef BACKEND
ifdef PROMPT
$(info Backend is set to: $(value BACKEND) and Prompt is set to: $(value PROMPT))
aws-vault-command := aws-vault exec $$AWS_VAULT_PROFILE --backend=$$BACKEND --prompt=$$PROMPT
$(info Your aws-vault command is set to: "$(value aws-vault-command)")
else
$(info Value for PROMPT variable is not set)
endif
else
$(info BACKEND and PROMPT variables are not set)
aws-vault-command := aws-vault exec $$AWS_VAULT_PROFILE
$(info Your aws-vault command is set to: "$(value aws-vault-command)")
endif

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
