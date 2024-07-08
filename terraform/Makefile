SELF_DIR ?= ./
CURRENT_DIR_NAME:=$(shell echo "${SELF_DIR}" | rev | cut -d'/' -f 1 | rev)
SETTINGS ?= voxsmart

ENV_EXTRA_VARS ?=
EXTRA_VARS ?=  $(shell test -f ${SETTINGS}.tfvars && echo "-var-file=${SETTINGS}.tfvars" || echo '')

export TF_github_app_id = ${GITHUB_APP_ID}
export TF_github_app_installation_id = ${GITHUB_APP_INSTALLATION_ID}
export TF_github_app_pem_file = ${GITHUB_APP_PEM_FILE}

get-current-dir:
	@echo $(SELF_DIR)

get-current-dir-name:
	echo $(EXTRA_VARS)
	@echo $(CURRENT_DIR_NAME)

#Terraform
terraform-login:
	terraform login

terraform-init:
	@cd '${SELF_DIR}'
	terraform init

terraform-plan:
	terraform plan ${EXTRA_VARS}

terraform-apply-approval:
	terraform apply ${EXTRA_VARS}
	@echo Apply operation run successfully

terraform-apply:
	terraform apply -auto-approve ${EXTRA_VARS}
	@echo Apply operation run successfully

terraform-destroy:
	terraform destroy -auto-approve ${EXTRA_VARS}
	@echo Destroy operation run successfully

terraform-destroy-approval:
	terraform destroy ${EXTRA_VARS}
	@echo Destroy operation run successfully

terraform-plan-destroy:
	terraform plan -destroy ${EXTRA_VARS}

terraform-import:
	terraform import ${EXTRA_VARS} '${ADDRESS}' '${ID}'

terraform-validate:
	@cd '${SELF_DIR}'
	terraform fmt -check -recursive -diff
	terraform validate

terraform-format:
	@cd '${SELF_DIR}'
	terraform fmt -recursive

terraform-console:
	@terraform console

terraform-output:
	@terraform output

terraform-plan-json:
	terraform plan -out tfplan.binary ${EXTRA_VARS}
	terraform show -json tfplan.binary > plan.json
