ifeq ($(USE_DOT_ENV),true) 
	include .env
endif

TF_DIR := deployment/terraform
TF_RUN=terraform -chdir=${TF_DIR}
TF_PLAN_FILE=apply.tfplan

tf-init:
	$(TF_RUN) init -reconfigure \
		-backend-config="bucket=${BUCKET_NAME}" \
		-backend-config="region=${AWS_DEFAULT_REGION}" \
		-backend-config="key=${BUCKET_KEY}"

tf-plan-show:
	$(TF_RUN) show \
		-json \
		${TF_PLAN_FILE}

tf-plan: tf-init
	$(TF_RUN) plan \
		-var-file=../environment/main.tfvars \
		-out=${TF_PLAN_FILE}

deploy: tf-plan
	$(TF_RUN) apply ${TF_PLAN_FILE}

tf-destroy:
	$(TF_RUN) plan -destroy -var-file=../environment/main.tfvars -out=${TF_PLAN_FILE}
	$(TF_RUN) apply ${TF_PLAN_FILE}
