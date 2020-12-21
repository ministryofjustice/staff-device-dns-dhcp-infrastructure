init:
	aws-vault exec moj-pttp-shared-services -- terraform init -reconfigure --backend-config="key=terraform.development.state"

plan:
	aws-vault clear && aws-vault exec moj-pttp-shared-services --duration=2h -- terraform plan

apply:
	aws-vault clear && aws-vault exec moj-pttp-shared-services --duration=2h -- terraform apply

destroy:
	aws-vault clear && aws-vault exec moj-pttp-shared-services --duration=2h -- terraform destroy

.PHONY: init apply destroy
