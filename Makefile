init:
	terraform init -reconfigure --backend-config="key=terraform.development.state"

destroy:
	aws-vault exec moj-pttp-development -- ./scripts/development_delete_auto_scaling_group_workaround
	aws-vault exec moj-pttp-shared-services -- terraform destroy

.PHONY: init destroy
