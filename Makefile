#!make
include .env
export

fmt:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform fmt --recursive

init:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform init -reconfigure \
	--backend-config="key=terraform.$$ENV.state"

init-upgrade:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform init -upgrade \
	--backend-config="key=terraform.$$ENV.state"

workspace-list:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform workspace list

workspace-select:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform workspace select $$ENV || \
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform workspace new $$ENV

validate:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform validate

plan-out:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform plan -no-color > $$ENV.tfplan

plan:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform plan

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

clean:
	rm -rf .terraform/ terraform.tfstate*

generate-tfvars:
	./scripts/generate_tfvars.sh


.PHONY:
	fmt init workspace-list workspace-select validate plan-out plan \
	refresh output apply state-list show destroy clean generate-tfvars
