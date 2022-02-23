SHELL := /usr/bin/env bash

all-test: clean tf-plan-eks

.PHONY: clean
clean:
	rm -rf .terraform

.PHONY: tf-plan-eks
tf-plan-eks:
	terraform init -backend-config ./environment/dev/backend.conf -reconfigure source && terraform validate && terraform plan -var-file ./environment/dev/base.tfvars source

.PHONY: tf-apply-eks
tf-apply-eks:
	terraform init -backend-config ./environment/dev/backend.conf -reconfigure source && terraform validate && terraform apply -var-file ./environment/dev/base.tfvars -auto-approve source

.PHONY: tf-destroy-eks
tf-destroy-test:
	terraform init -backend-config ./environment/dev/backend.conf -reconfigure source && terraform validate && terraform destroy -var-file ./environment/dev/base.tfvars source -auto-approve source

.PHONY: tf-fmt
fmt:
	for i in $$(find . -name \*.tf | grep -v ".terraform"); do terraform fmt -write=true $$i; done

.PHONY: tf-sec
tfsec:
	tfsec .
