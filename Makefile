init:
	terraform init -reconfigure --backend-config="key=terraform.development.state"

.PHONY: init
