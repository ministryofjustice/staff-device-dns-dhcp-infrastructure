# Corsham Test Site

Remote testing of the DHCP / DNS services are performed from a virtual machine (VM) running in the Corsham data center.

These tests run on an infinite loop, sending a total of 50 requests at a rate of two requests per second, emulating two concurrent connections with `perfdhcp`.
To access this VM you need to go through the bastion set up in production, which is on the same network (via the [Transit Gateway](https://aws.amazon.com/transit-gateway)) as the VM.

Follow the steps below to gain access to the VM for debugging:

## Create the Corsham VM bastion (jump box)

This should only be used to get access to the VM and should not be left running in production.

This is integrated with the production MoJ network so will only work on our production AWS account.

1. Add your public IP address to AWS SSM parameter store `/staff-device/corsham_testing/bastion_allowed_ingress_ip`.

2. Modify the `enable_corsham_test_bastion` variable in `./variables.tf` and set it to `true`.

3. Commit this to the `main` git branch and push it up.

4. Ensure CI has created this instance.

## SSH onto the bastion server

1. Log into the production AWS console, and go to the SSM Parameter Store.

2. Copy the contents of the SSH key kept under `/corsham/testing/bastion/private_key` and save it to a local file `corsham_test.pem`

3. Change the permission of the pem file by running:

    ```bash
    chmod 600 corsham_test.pem
    ```

4. Copy the IP address of the bastion server found under `/corsham/testing/bastion/ip` (referred to as <BASTION_IP> below)

5. SSH onto the bastion server:

    ```bash
    ssh -i corsham_test.pem ubuntu@<BASTION_IP>
    ```

### SSH onto the Corsham VM from the bastion server

1. Copy the IP address for the VM found under `/corsham/testing/vm/ip` in SSM (referred to as <VM_IP> below)

2. Copy the SSH password for the VM found under `/corsham/testing/vm/password` in SSM (referred to as <VM_PASSWORD> below)

3. SSH onto the Corsham VM:

    ```bash
    ssh mt@<VM_IP>
    ```

4. When prompted for the password enter `<VM_PASSWORD>`

### Run PerfDHCP

1. Execute the test script
    
    ```bash
    ./run_perfdhcp
    ```

The results of the test will display when `perfdhcp` has completed.
