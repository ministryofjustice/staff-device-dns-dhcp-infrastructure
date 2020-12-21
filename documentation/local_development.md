# Local Development
## Prerequisites
Install [aws-vault](https://github.com/99designs/aws-vault#installing) (minimum version 6.0).

## Setup
Create a profile in [aws-vault](https://github.com/99designs/aws-vault#quick-start) called '`moj-pttp-shared-services`'. This profile will store your AWS credentials for the shared services account.

```shell
 aws-vault add moj-pttp-shared-services
```

Clone this repo and create a file in the same directory. Name the file `terraform.tfvars`. This `terraform.tfvars` file contains the variables for local development. An example file can be obtained from the Parameter Store of the AWS Shared Services account:

`/staff-device/dns-dhcp/terraform.tfvars`

Please make sure to replace `<your_namespace>` with your own workspace name in the example tfvars file.

### Initialise the repo:
```shell
  make init
```

### Create your workspace:

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace new "your-user-name"
```

### Select your workspace:

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace select "your-user-name"
```

### Build your development infrastructure:

```shell
  make apply
```

### Destroy your development infrastructure:

```shell
  make destroy
```