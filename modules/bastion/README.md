# SSM Bastion Access

This bastion is not accessible via the public internet, it does not have a public ip. To connect to it one must use the SSM Session Manager.

## Prerequisites

- aws cli
- [Session Manager plugin for the AWS CLI][plugin]

On a Mac install the Session Manager plugin with [Homebrew][brew]

```shell
brew install --cask session-manager-plugin
```

## Connection from terminal

You will need the `instance id` of the bastion EC2 instance - this useful command will return a table of instances

```shell
export AWS_PROFILE=the_awsprofile_name
```

```shell

aws --profile ${AWS_PROFILE} \
ec2 describe-instances \
--query 'Reservations[].Instances[].[InstanceId,InstanceType,PublicIpAddress,Tags[?Key==`Name`]| [0].Value]' \
--output table

```

Example result

```shell
---------------------------------------------------------------------------------------------------------------
|                                              DescribeInstances                                              |
+---------------------+--------------+-----------------+------------------------------------------------------+
|  i-0199asds08e827733|  t3.xlarge   |  1.2.3.4        |  MOJ-AW2-PAN01A                                      |
|  i-074571ddc6dddddcc|  t2.micro    |  1.3.2.51       |  None                                                |
|  i-0c4tttbbbb31fd3e6|  t2.nano     |  None           |  staff-infrastructure-development-net-svc-bastion    |
+---------------------+--------------+-----------------+------------------------------------------------------+

```

Grab the id and run the following command

```shell
aws --profile ${AWS_PROFILE} ssm start-session --target i-0c4tttbbbb31fd3e6
```

Now you will be logged in.

[plugin]: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
[brew]: https://brew.sh/
