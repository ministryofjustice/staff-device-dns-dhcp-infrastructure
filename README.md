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

## Corsham Test site

We do remote testing of the DHCP service from a virtual machine running in Corsham.

These tests run on an infinite loop, sending a total of 50 requests at a rate of 2 requests per second, emulating 2 concurrent connections with `perfdhcp`.
To access this VM you need to go through the bastion set up in production, which is on the same network (via the Transit Gateway) as the VM.

Follow the steps below to gain access to the VM for debugging:

### Create the Corsham VM bastion (jump box)

This should only be used to get access to the VM and should not be left running in production.

This is integrated with the production MoJ network so will only work on our production AWS account.

1. Modify the `enable_corsham_test_bastion` variable in ./variables.tf and set it to true.

2. Commit this to the `main` git branch and push it up.

3. Ensure CI has created this instance.

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

6. Copy the IP address for the VM found under `/corsham/testing/vm/ip` in SSM  (referred to as <VM_IP> below)

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
