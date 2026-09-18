.PHONY := fmt init plan apply

ifndef AWS_SESSION_TOKEN
  $(error Not logged in, please run 'assume')
endif

fmt:
	@terraform -chdir=terraform fmt

init:
	@terraform -chdir=terraform init

plan: init
	@terraform -chdir=terraform plan

apply: init
	@terraform -chdir=terraform apply
