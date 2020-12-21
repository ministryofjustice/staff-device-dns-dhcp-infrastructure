# Getting Started
The Terraform that makes up this service is designed to be comprehensive and fully automated.

The current development flow is to run the Terraform from your own machine locally. Once the changes have tested, you can commit the changes to the `main` branch, where they will be automatically deployed through each of the various environments.

These environments include:

- Development
- Pre-production
- Production

When running Terraform locally, you will be creating the infrastructure in the Development AWS environment. Terraform is able to namespace your infrastructure by using Terraform workspaces. Naming is managed through the label module in Terraform. The combination of these two tools will prevent name clashes with other developers and environments, allowing you to test your changes in isolation before committing them to the master branch.

To start developing on this service, follow the guidance below:

## Install required tools
- [AWS CLI](https://aws.amazon.com/cli/)
- [AWS vault](https://github.com/99designs/aws-vault#installing)
- [tfenv](https://github.com/tfutils/tfenv)

## Authenticate with AWS

Terraform is run locally in a similar way to how it is run on the build pipelines.

It assumes an IAM role defined in the Shared Services, and target AWS accounts to gain access to the Development environment. This is done in the Terraform AWS provider with the assume_role configuration.

You will authenticate with the Shared Services AWS account, which then will assume the role into the target account.

Assuming you have been given access to the Shared Services account, you can add it to [AWS Vault](https://github.com/99designs/aws-vault#quick-start):

```shell
 aws-vault add moj-pttp-shared-services
```
Enter your IAM Access Key and Secret Access Key

## Set up MFA on your AWS account

Multi-Factor Authentication (MFA) is required on AWS accounts in this project. You will need to do this for both your Dev and Shared Services AWS accounts.

The steps to set this up are as follows:

- Navigate to the AWS console for a given account.
- Click on "IAM" under Services in the AWS console.
- Click on "Users" in the IAM menu.
- Find your username within the list and click on it.
- Select the security credentials tab, then assign an MFA device using the "Virtual MFA device" option (follow the on-screen instructions for this step).
- Edit your local `~/.aws/config` file with the key value pair of `mfa_serial=<iam_role_from_mfa_device>` for each of your accounts.
- The value for `<iam_role_from_mfa_device>` can be found in the AWS console on your IAM user details page, under "Assigned MFA device". Ensure that you remove the text "(Virtual)" from the end of key value pair's value when you edit this file.

## terraform.tfvars

This file is used to set default local development variables, which Terraform depends on.

When creating infrastructure through the build pipeline, these variables are pulled from SSM Parameter Store and used by Terraform.

You can find an example of the variables file in SSM Parameter store in the Shared Services AWS account.

The name of the parameter is: `/staff-device/dns-dhcp/terraform.tfvars`

Please ensure you replace `<your_namespace>` with your own workspace name in the example `tfvars` file.

### Initialize your local Terraform state
```shell
  aws-vault exec moj-pttp-shared-services -- make init
```

### Create your Terraform workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace new "YOUR_UNIQUE_WORKSPACE_NAME"
```

### Ensure you are on the correct workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace select "YOUR_UNIQUE_WORKSPACE_NAME"
```

### Apply your infrastructure

```shell
  make apply
```

### Destroying your infrastructure

```shell
  make destroy
```