init:
	aws-vault exec moj-pttp-shared-services -- terraform init -reconfigure \
	--backend-config="key=terraform.development.state"

apply:
	aws-vault clear && aws-vault exec moj-pttp-shared-services --duration=2h -- terraform apply

destroy:
	aws-vault clear && aws-vault exec moj-pttp-shared-services --duration=2h -- terraform destroy

fmt:
	terraform fmt --recursive

validate:
	aws-vault clear && aws-vault exec moj-pttp-shared-services -- terraform validate

.PHONY: init apply destroy fmt validate
