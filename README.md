# DNS / DHCP AWS Infrastructure

## Introduction

This repository contains the Terraform code to build the AWS infrastructure for the Ministry of Justice's DNS and DHCP platform. The infrastructure is implemented in AWS and applied using [AWS CodePipelines](https://aws.amazon.com/codepipeline/) specified in the Shared Services management account.

Where possible, the running applications are defined and run as docker containers using [AWS Fargate](https://aws.amazon.com/fargate/) or [ECS](https://aws.amazon.com/ecs/)

## Related Repositories

This repository defines the **system infrastructure only**. Specific components and applications are defined in their own logical external repositories.

- [Shared Services](https://github.com/ministryofjustice/pttp-shared-services-infrastructure)
- [DNS DHCP Admin Portal](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin)
- [DNS Server](https://github.com/ministryofjustice/staff-device-dns-server)
- [DHCP Server](https://github.com/ministryofjustice/staff-device-dhcp-server)

## Architecture

![architecture](diagrams/pttp-dns-dhcp-infra.png)
[Image Source](diagrams/pttp-dns-dhcp-infra.drawio)

## Authentication with Azure AD

Azure AD provides the authorization backend, via [AWS Cognito](https://aws.amazon.com/cognito/), and is manually provisioned following the [Azure AD manual provisioning guide](docs/azure_ad.md).

## Local Development

[Install aws-vault](https://github.com/99designs/aws-vault#installing) (minimum version 6.0) and [add the MoJ shared services account](https://github.com/99designs/aws-vault#quick-start) as 'moj-pttp-shared-services'.

Initialise the repo:

```shell
  make init
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
  make apply
```

## Corsham Test site

We do remote testing of the DHCP service from a virtual machine running in Corsham.

These tests run on an infinite loop, sending a total of 50 requests at a rate of 2 requests per second, emulating 2 concurrent connections with `perfdhcp`.
To access this VM you need to go through the bastion set up in production, which is on the same network (via the Transit Gateway) as the VM.

Follow the steps below to gain access to the VM for debugging:

### Create the Corsham VM bastion (jump box)

This should only be used to get access to the VM and should not be left running in production.

This is integrated with the production MoJ network so will only work on our production AWS account.

1. Add your public IP address to SSM parameter store, `/staff-device/corsham_testing/bastion_allowed_ingress_ip`.

2. Modify the `enable_corsham_test_bastion` variable in ./variables.tf and set it to true.

3. Commit this to the `main` git branch and push it up.

4. Ensure CI has created this instance.

### SSH onto the bastion server

1. Log into the production AWS console, and go to the SSM Parameter Store.

2. Copy the contents of the SSH key kept under `/corsham/testing/bastion/private_key` and save it to a local file corsham_test.pem

3. Change the permission of the pem file by running:

```bash
chmod 600 corsham_test.pem
```

4. Copy the IP address of the bastion server found under `/corsham/testing/bastion/ip` (refered to as <BASTION_IP> below)

5. SSH onto the bastion server:

```bash
ssh -i corsham_test.pem ubuntu@<BASTION_IP>
```

### SSH onto the Corsham VM from the bastion server

6. Copy the IP address for the VM found under `/corsham/testing/vm/ip` in SSM (referred to as <VM_IP> below)

7. Copy the SSH password for the VM found under `/corsham/testing/vm/password` in SSM (referred to as <VM_PASSWORD> below)

8. SSH onto the Corsham VM:

```bash
ssh root@<VM_IP>
```

9. When prompted for the password enter <VM_PASSWORD>

### Run the PerfDHCP

10. Execute the test script

```bash
./run_perfdhcp
```

The results of the test will display when perfdhcp has completed.
