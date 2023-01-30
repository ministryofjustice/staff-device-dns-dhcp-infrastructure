#!make
include .env
export

fmt:
	terraform fmt --recursive

init:
	terraform init -reconfigure \
	--backend-config="key=terraform.development.state"

generate-tfvars:
	./scripts/generate_tfvars.sh

validate:
	terraform validate

plan:
	terraform plan -out terraform.tfplan

apply:
	terraform apply
	./scripts/publish_terraform_outputs.sh

destroy:
	terraform destroy

.PHONY: fmt init validate plan apply destroy
