# cloud-platform-terraform-_template_

[![Releases](https://img.shields.io/github/release/ministryofjustice/cloud-platform-terraform-template/all.svg?style=flat-square)](https://github.com/ministryofjustice/cloud-platform-terraform-template/releases)

_note: Please remove all comments in italics and fill where required>_

_Short describion of the module_
_This Terraform module ......_

## Usage

_Describe how to use the module_
_example_:

```hcl
module "example_sqs" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-sqs?ref=version"

  environment-name       = "example-env"
  team_name              = "cloud-platform"
  infrastructure-support = "example-team@digtal.justice.gov.uk"
  application            = "exampleapp"
  sqs_name               = "examplesqsname"

  # Set encrypt_sqs_kms = "true", to enable SSE for SQS using KMS key.
  encrypt_sqs_kms = "false"

  # existing_user_name     = module.another_sqs_instance.user_name
  
  # NB: If you want multiple queues to share an IAM user, you must create one queue first,
  # letting it create the IAM user. Then, in a separate PR, you can create all the other
  # queues. Otherwise terraform cannot resolve the cyclic dependency of creating multiple
  # queues but one IAM user, because it cannot work out which queue will successfully
  # create the user, and which queues will reuse that user.

  providers = {
    aws = aws.london
  }
}

```
## Inputs

_Describe what to pass the module_
_example_:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| visibility_timeout_seconds | The visibility timeout for the queue | integer | `30` | no |
| message_retention_seconds | The number of seconds Amazon SQS retains a message| integer | `345600` | no |
| max_message_size | Max message size in bytes | integer | `262144` | no |
| delay_seconds | Seconds that message will be delayed for | integer | `0` | no |
| receive_wait_time_seconds | Seconds for which a ReceiveMessage call will wait for a message to arrive | integer | `0` | no |
| kms_master_key_id | The ID of an AWS-managed customer master key | string | - | no |
| kms_data_key_reuse_period_seconds | Seconds for which Amazon SQS can reuse a data key | integer | `0` | no |
| existing_user_name | if set, adds a policy rather than creating a new IAM user | string | - | no |
| redrive_policy | if set, specifies the ARN of the "DeadLetter" queue | string | - | no |
| encrypt_sqs_kms | if set to true, it enables SSE for SQS using KMS key | string | `false` | no |


## Tags

Some of the inputs are tags. All infrastructure resources need to be tagged according to the [MOJ techincal guidance](https://ministryofjustice.github.io/technical-guidance/standards/documenting-infrastructure-owners/#documenting-owners-of-infrastructure). The tags are stored as variables that you will need to fill out as part of your module.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| application |  | string | - | yes |
| business-unit | Area of the MOJ responsible for the service | string | `mojdigital` | yes |
| environment-name |  | string | - | yes |
| infrastructure-support | The team responsible for managing the infrastructure. Should be of the form team-email | string | - | yes |
| is-production |  | string | `false` | yes |
| team_name |  | string | - | yes |
| sqs_name |  | string | - | yes |

## Outputs

_Describe the outputs_
_example_

| Name | Description |
|------|-------------|
| access_key_id | Access key id for the credentials. |
| secret_access_key | Secret for the new credentials. |
| sqs_id | The URL for the created Amazon SQS queue. |
| sqs_arn | The ARN of the SQS queue. |
| user_name | to be used for other queues that have `existing_user_name` set |
| sqs_name | The name of the SQS queue |

## Reading Material

_add link to external source_
