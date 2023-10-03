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

Assuming you have been granted necessary access permissions to the Shared Service Account, please follow the NVVS DevOps best practices provided [step-by-step guide](https://ministryofjustice.github.io/nvvs-devops/documentation/team-guide/best-practices/use-aws-sso.html#re-configure-aws-vault) to configure your AWS Vault and AWS Cli with AWS SSO.

## Prepare the variables

Run the following command, enter your AWS-VAULT password when requested. The script will retrive the SSM Parameters (by default for development environment) and write out a `.env` file.
This file is used by the Makefile to source the TF_VARS required.

```shell
export AWS_PROFILE=mojo-shared-services-cli

./scripts/generate-env-file.sh
```



| :bell: HELP                                                                                                            |
| :--------------------------------------------------------------------------------------------------------------------- |
| See [Create Terraform workspace](#create-terraform-workspace) section to find out how to create a terraform workspace! |


## Initialize your Terraform

```shell
make init
```

## Switch to an isolated workspace

If you do not have a Terraform workspace created already, use the command below to create a new workspace.

### Create Terraform workspace

```shell
AWS_PROFILE=mojo-shared-services-cli terraform workspace new "YOUR_UNIQUE_WORKSPACE_NAME"
```

This should create a new workspace and select that new workspace at the same time.

> If you already have a workspace created use the command below to select the right workspace before continue.
>
> ### View Terraform workspace list
>
> ```shell
> AWS_PROFILE=mojo-shared-services-cli terraform workspace list
> ```
>
> ### Select a Terraform workspace
>
> ```shell
> make workspace-select "YOUR_WORKSPACE_NAME"
> ```

## Finally spin up your own Infra

```shell
make apply
```

This should create your own Network Services infra in a separate VPC in Development AWS Account.

| :boom: REMEMBER                                                |
| :------------------------------------------------------------- |
| To destroy your dev AWS infrastructure, when no longer needed! |

Use the following command to destroy the infrastructure:

```shell
make destroy
```
