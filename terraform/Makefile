SELF_DIR ?= ./
CURRENT_DIR_NAME:=$(shell echo "${SELF_DIR}" | rev | cut -d'/' -f 1 | rev)
SETTINGS ?= voxsmart

ENV_EXTRA_VARS ?=
EXTRA_VARS ?=  $(shell test -f ${SETTINGS}.tfvars && echo "-var-file=${SETTINGS}.tfvars" || echo '')

AWS_ACCOUNT=$(shell aws sts get-caller-identity --query 'Account' --output text)

export KEY_NAME ?= terraform.tfstate
AWS_DEFAULT_REGION ?= eu-west-1
TERRAFORM_BUCKET_NAME ?= djimenezc-terraform-remote-state-${AWS_ACCOUNT}
TERRAFORM_LOCK_TABLE_NAME ?= terraform-locks

export TF_VAR_github_app_id ?= ${GITHUB_APP_ID}
export TF_VAR_github_app_installation_id ?= ${GITHUB_APP_INSTALLATION_ID}
export TF_VAR_github_app_pem_file ?= ${GITHUB_APP_PEM_FILE}
export TF_VAR_github_app_pem_file_path ?= ${GITHUB_APP_PEM_FILE}
export TF_workspace ?= $(SETTINGS)
export TF_VAR_aws_region ?= ${AWS_DEFAULT_REGION}

get-current-dir:
	@echo $(SELF_DIR)

get-current-dir-name:
	echo $(EXTRA_VARS)
	@echo $(CURRENT_DIR_NAME)

get-aws-account:
	aws sts get-caller-identity

#Terraform
aws-terraform-create-s3-backend:
	@if aws s3 ls "s3://$(TERRAFORM_BUCKET_NAME)" 2>&1 | grep -q 'NoSuchBucket'; then \
  		echo "Creating bucket $(TERRAFORM_BUCKET_NAME)"; \
		aws s3api create-bucket --bucket $(TERRAFORM_BUCKET_NAME) --region ${AWS_DEFAULT_REGION} \
			--create-bucket-configuration LocationConstraint=${AWS_DEFAULT_REGION}; \
		aws s3api put-bucket-encryption --bucket $(TERRAFORM_BUCKET_NAME) \
			--server-side-encryption-configuration \
			'{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'; \
		aws s3api put-public-access-block \
            --bucket $(TERRAFORM_BUCKET_NAME) \
            --public-access-block-configuration \
            'BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true'; \
		aws s3api get-public-access-block --bucket $(TERRAFORM_BUCKET_NAME); \
	fi
	-aws dynamodb create-table --table-name $(TERRAFORM_LOCK_TABLE_NAME) \
	--attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH \
	 --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

aws-terraform-create-s3-backend-rollback:
	aws s3api delete-bucket --bucket $(TERRAFORM_BUCKET_NAME)
	aws dynamodb delete-table --table-name $(TERRAFORM_LOCK_TABLE_NAME)

terraform-login:
	terraform login

terraform-init:
	@cd '${SELF_DIR}'
	terraform init -backend-config=bucket=${TERRAFORM_BUCKET_NAME} -backend=true -reconfigure -backend-config=key=${KEY_NAME}

terraform-create-workspace:
	@cd '${SELF_DIR}'
	terraform workspace select ${TF_VAR_aws_region} || terraform workspace new ${TF_VAR_aws_region}

terraform-plan: terraform-create-workspace
	terraform plan ${EXTRA_VARS}

terraform-apply-approval: terraform-create-workspace
	terraform apply ${EXTRA_VARS}
	@echo Apply operation run successfully

terraform-apply: terraform-create-workspace
	terraform apply -auto-approve ${EXTRA_VARS}
	@echo Apply operation run successfully

terraform-destroy: terraform-create-workspace
	terraform destroy -auto-approve ${EXTRA_VARS}
	@echo Destroy operation run successfully

terraform-destroy-approval: terraform-create-workspace
	terraform destroy ${EXTRA_VARS}
	@echo Destroy operation run successfully

terraform-plan-destroy: terraform-create-workspace
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
