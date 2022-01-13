# Getting Started

The Terraform that makes up this service is designed to be comprehensive and fully automated.

The development flow is to run the Terraform from your own machine locally.
 Once the changes have been tested, you can merge changes to the `main` branch,
 where they will be automatically deployed through each of the various environments.

Each environment is implemented using a separate AWS account, these are:

- Development
- Pre-production
- Production

When running Terraform locally, infrastructure will be created in the AWS Development environment.
 Terraform is able to namespace your infrastructure by using
 [workspaces](https://www.terraform.io/docs/state/workspaces.html).
 Naming is managed through the label module in Terraform.
 The combination of these two tools will prevent name clashes with other developers,
 infrastructure and environments, allowing development in isolation.

To start developing on this service, follow the guidance below:

## Install required tools

- [AWS CLI](https://aws.amazon.com/cli/)
- [AWS vault](https://github.com/99designs/aws-vault#installing)
- [tfenv](https://github.com/tfutils/tfenv)

## Authenticate with AWS

Terraform is run locally in a similar way to how it is run on the build pipelines.

It assumes an IAM role defined in the Shared Services, and targets the AWS account to gain access to the Development environment.
 This is done in the Terraform AWS provider with the `assume_role` configuration.

Authentication is made with the Shared Services AWS account, which then assumes the role into the target environment.

Please follow the CloudOps best practices provided [step-by-step guide](https://ministryofjustice.github.io/cloud-operations/documentation/team-guide/best-practices/use-aws-sso.html#re-configure-aws-vault) to configure your AWS Vault.

## Prepare the variables  

1. Copy `.env.example` to `.env`
1. Modify the `.env` file and replace the following placeholders:  

| Placeholders | How? |
| --- | --- |
| `<shared-services-aws-vault-profile>` | with your **AWS-VAULT** profile name for the **Shared Services** AWS account. |
| `<your_terraform_workspace>` | with your terraform workspace name. :bell: |  

Also provide values for `backend` and `prompt` variables. Instructions for these two variables are provided in the `.env.example` file.

| :bell: HELP |  
|:-----|  
| See [Create Terraform workspace](#create-terraform-workspace) section to find out how to create a terraform workspace! |  

## terraform.tfvars

This file is used to set default local development variables, which Terraform depends on.

When creating infrastructure through the build pipeline, these variables are retrieved from SSM Parameter Store and used by Terraform.

You can find an example of the variables file in SSM Parameter store in the Shared Services AWS account.

The name of the parameter is: `/staff-device/dns-dhcp/terraform.tfvars`

Please ensure to replace '[your-tf-workspace]' with your own workspace name in the example `tfvars` file.

## Initialize your Terraform

```shell
make init
```

## Switch to an isolated workspace

If you do not have a Terraform workspace created already, use the command below to create a new workspace.

### Create Terraform workspace  

```shell
aws-vault exec <shared-services-aws-vault-profile> -- terraform workspace new "YOUR_UNIQUE_WORKSPACE_NAME"
```  

This should create a new workspace and select that new workspace at the same time.

>If you already have a workspace created use the command below to select the right workspace before continue.
>
>### View Terraform workspace list
>
>```shell
>aws-vault exec <shared-services-aws-vault-profile> -- terraform workspace list
>```
>
>### Select a Terraform workspace
>
>```shell
>aws-vault exec <shared-services-aws-vault-profile> -- terraform workspace select "YOUR_WORKSPACE_NAME"
>```

## Finally spin up your own Infra

```shell
make apply
```  

This should create your own Network Services infra in a separate VPC in Development AWS Account.

| :boom: REMEMBER |
|:-----|
| To destroy your dev AWS infrastructure, when no longer needed! |  

Use the following command to destroy the infrastructure:  

```shell
make destroy
```  
