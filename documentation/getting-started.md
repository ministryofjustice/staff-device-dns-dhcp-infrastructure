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

It assumes an IAM role defined in the Shared Services, and targets the AWS account to gain access to the Development environment. This is done in the Terraform AWS provider with the `assume_role` configuration.

Authentication is made with the Shared Services AWS account, which then assumes the role into the target environment.

Assuming you have been given access to the Shared Services account, you can add it to [AWS Vault](https://github.com/99designs/aws-vault#quick-start):

```shell
 aws-vault add moj-pttp-shared-services
```

## Set up MFA on AWS accounts

Multi-Factor Authentication (MFA) is required on AWS accounts in this project.

The steps to set this up are as follows:

- Configure MFA in the AWS console.
- Edit your local `~/.aws/config` file with the key value pair of `mfa_serial=<iam_role_from_mfa_device>` for each of your accounts.
- The value for `<iam_role_from_mfa_device>` can be found in the AWS console on the IAM user details page, under "Assigned MFA device". Ensure that the text "(Virtual)" is removed from the end of the key value pair's entry when editing this file.

## terraform.tfvars

This file is used to set default local development variables, which Terraform depends on.

When creating infrastructure through the build pipeline, these variables are retrieved from SSM Parameter Store and used by Terraform.

You can find an example of the variables file in SSM Parameter store in the Shared Services AWS account.

The name of the parameter is: `/staff-device/dns-dhcp/terraform.tfvars`

Please ensure to replace `<your_namespace>` with your own workspace name in the example `tfvars` file.

### Initialize local Terraform state

```shell
  make init
```

### Create Terraform workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace new "YOUR_UNIQUE_WORKSPACE_NAME"
```

### Switch to isolated workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace select "YOUR_UNIQUE_WORKSPACE_NAME"
```

### Apply infrastructure

```shell
  make apply
```

### Destroy infrastructure

```shell
  make destroy
```
