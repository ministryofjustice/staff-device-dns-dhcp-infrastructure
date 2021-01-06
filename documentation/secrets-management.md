# Secrets Management

All secrets are kept in [AWS SSM Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html) in the Shared Services AWS account.

Parameter store contains a combination of encrypted highly confidential secrets, and environment specific values (Development, Pre-production and Production).
Terraform pulls these during build, as defined in the [buildspec.yml](../buildspec.yml) file.

To pass a new SSM parameter into Terraform as a variable, prepend the name with `TF_VAR_`.

Secrets can be managed through the AWS console interface or programatically by using the AWS CLI:

1. View list of secrets

```sh
aws-vault exec moj-pttp-shared-services -- aws ssm describe-parameters
```

2. View individual secret

```sh
aws-vault exec moj-pttp-shared-services -- aws ssm get-parameter \
  --name "/some/top/secret" \
  --with-decryption
```

3. Add secret

```sh
aws-vault exec moj-pttp-shared-services -- aws ssm put-parameter \
  --name "/a/new/secret" \
  --description "Some new secret" \
  --value "topsecret" \
  --type SecureString \
  --key-id '[ENCRYPTION_KEY_ARN_FOR_SECRET]'
```

3. Update existing secret

```sh
aws-vault exec moj-pttp-shared-services -- aws ssm put-parameter \
  --name "/a/new/secret" \
  --description "Some new secret" \
  --value "topsecret" \
  --type SecureString \
  --key-id '[ENCRYPTION_KEY_ARN_FOR_SECRET]'
  --overwrite
```

4. Delete secret

```sh
aws-vault exec moj-pttp-shared-services -- aws ssm delete-parameter \
  --name "/my/top/secret"
```

## Terraform outputs

The Terraform outputs of the infrastructure is published to SSM parameter store as a secret.
Related pipelines such as the DHCP server and DNS server depend on these values to do deployments and publishing containers to target registries.

This pattern prevents name changes in the infrastructure breaking related pipelines that depend on this infrastructure.
