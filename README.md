# DNS / DHCP AWS Infrastructure

## Run locally

Initialise the repo:

```shell
  aws-vault exec moj-pttp-shared-services -- make init
```

Create your workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace new "your-user-name"
```

Select your workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform workspace select "your-user-name"
```

Select your workspace

```shell
  aws-vault exec moj-pttp-shared-services -- terraform apply
```

## Docker images

The ISC Kea DHCP service hosted by this service runs in a Docker container.
The code for building this container can be found [here](https://github.com/ministryofjustice/staff-device-dhcp-server).

## Authentication with Azure AD

Azure AD provides our authorization backend and is not provisioned through CLI/Terraform. Follow this guide for manual steps to build Azure AD infrastructure.

[Azure AD manual provisioning guide](docs/azure_ad.md)
