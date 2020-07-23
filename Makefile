init:
	terraform init --backend-config="key=terraform.development.state"

.PHONY: init
