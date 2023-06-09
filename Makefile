ifeq ($(USE_DOT_ENV),true) 
	include .env
endif

TF_DIR := deployment/terraform
TF_RUN=terraform -chdir=${TF_DIR}
TF_PLAN_FILE=apply.tfplan

COUNT := $(words $(PLAN_KEYS_TO_WATCH))
SEQUENCE := $(shell seq 1 $(COUNT))
render-user-data:
	rm -f ${TF_DIR}/.user_data.sh
	cat ${TF_DIR}/user_data_init.sh >> ${TF_DIR}/.user_data.sh
	$(foreach var,$(SEQUENCE),\
	export PLAN_KEY_TO_WATCH=$(word $(var), $(PLAN_KEYS_TO_WATCH)) && \
	export BUILD_TIMEOUT_THRESHOLD_SECONDS=$(word $(var), $(BUILD_TIMEOUT_THRESHOLD_SECONDS_LIST)) && \
	cat ${TF_DIR}/user_data_docker_run.sh | envsubst >> ${TF_DIR}/.user_data.sh;)

tf-init:
	$(TF_RUN) init -reconfigure \
		-backend-config="bucket=${BUCKET_NAME}" \
		-backend-config="region=${AWS_DEFAULT_REGION}" \
		-backend-config="key=${BUCKET_KEY}"

tf-plan: tf-init render-user-data
	$(TF_RUN) plan \
		-var-file=../environment/main.tfvars \
		-out=${TF_PLAN_FILE}

deploy: tf-plan
	$(TF_RUN) apply ${TF_PLAN_FILE}

tf-destroy:
	$(TF_RUN) plan -destroy -var-file=../environment/main.tfvars -out=${TF_PLAN_FILE}
	$(TF_RUN) apply ${TF_PLAN_FILE}
