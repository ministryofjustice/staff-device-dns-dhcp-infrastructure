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

### Destroying infrastructure

The process of destroying infrastructure is an automated 2 step process that has been encapsulated in a Makefile command.

Run:

```shell
make destroy # note no aws-vault prefix required as this is in the Makefile 
```

This will:
1. Remove the Auto scaling group for the DNS and DHCP servers through the AWS command line
2. Run `terraform destroy` after that to destroy the remaining services.

*This is a workaround for a dependency bug in Terraform where the order within which services are torn down is incorrect.
By default Terraform will attempt to destroy the ECS service / cluster before removing the auto scaling group.
This will result in a timeout as the EC2 instances within the auto scaling group are still running.*

## Docker images

The ISC Kea DHCP service hosted by this service runs in a Docker container.
The code for building this container can be found [here](https://github.com/ministryofjustice/staff-device-dhcp-server).

## Authentication with Azure AD

Azure AD provides our authorization backend and is not provisioned through CLI/Terraform. Follow this guide for manual steps to build Azure AD infrastructure.

[Azure AD manual provisioning guide](docs/azure_ad.md)

## Corsham Test site

We do remote testing of the DHCP service from a virtual machine running in Corsham.
To access this VM you need to go through the bastion set up in production, which is on the same network (via the Transit Gateway) as the VM.

### Bastion details:

SSH key - `/corsham/testing/bastion/private_key`

Once on the Bastion run:

```bash
ssh root@<VM_IP_ADDRESS>
```

### VM details:

IP address - `/corsham/testing/vm/ip_address`
Password - `/corsham/testing/vm/password`

Once on the VM, we have a Docker container, provisioned with perfDHCP that can be used to run the tests.

Run:
```bash
cd ~/smoke_test
docker build --network host -t test .
docker run --network host -t test
```

This will run perfDHCP against the production DHCP Network load balancers.
The output will display the test results.
