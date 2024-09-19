# RDS Bastion

In order to carry out various maintenance tasks such as obtaining a database dump for loading into a local development DB; or obtain data that currently isn't available via an export mechanism; a bastion is created.

The bastion doesn't have any service exposed to the public like a "jump box" bastion e.g. SSH on port 22 as it is only accessible via the AWS Session Manager.

The routine is

- Enable

  - Spin up a bastion
    - Enable the bastion via an "enable" flag set in AWS SSM Parameter Store to `true`.
    - Deploy by running the CI pipeline.


- Configure
  - Prepare Terraform locally for the environment.


- Action
  - Create an SSM Session.
  - Retrieve connection details.
  - Carry out required procedure.
    - Get DB Dump.
    - Query DB.


- Removal
  - Disallow the bastion via an "enable" flag set in AWS SSM Parameter Store to `false`.
  - Omit by running the CI pipeline.

## Enable

### Spin up a bastion

Navigate to the ssm parameter store in the Shared Services AWS account.
Set the boolean value for 
  - Admin DB: `/staff-device/dns-dhcp/{environment}/enable_rds_admin_bastion` in [AWS SSM Parameter Store](https://eu-west-2.console.aws.amazon.com/systems-manager/parameters/?region=eu-west-2&tab=Table) to `true`
  - DHCP Server DB: `/staff-device/dns-dhcp/{environment}/enable_rds_admin_bastion` in [AWS SSM Parameter Store](https://eu-west-2.console.aws.amazon.com/systems-manager/parameters/?region=eu-west-2&tab=Table) to `true`
  - Run the `Staff-Device-DNS-DHCP-Infrastructure` [pipeline](https://eu-west-2.console.aws.amazon.com/codesuite/codepipeline/pipelines/Staff-Device-DNS-DHCP-Infrastructure/view?region=eu-west-2) to create the bastion instance.


## Configure

### Prepare Terraform locally for the environment.

We will need to query the Terraform state for the environment we need to run the init command, which will get then necessary env vars and terraform providers and modules.
For the `development` environment we do not need to add an ENV_ARGUMENT

```
make clean
make init
make init
```

For pre-production and production we do add the ENV_ARGUMENT as shown below.

```
make clean
make init ENV_ARGUMENT=production
make init ENV_ARGUMENT=production
```


## Action

### run the script to identify the bastion instance id

```
make aws_describe_instances
```

Then identify the running bastion host

```
i-019174128cf7b4563|  t3a.small  |  None           |  running |  mojo-production-rds-admin-bastion
```

### Start session on bastion

Run make command with instance id

```
make aws_ssm_start_session INSTANCE_ID=i-019174128cf7b4563
```

When the SSM session starts issue `sudo su -` command.

### Configure

The bastions are now configured at deployment time with the following AWS role to transfer files to (or from) an S3 transfer bucket.

Should this not be the case for any reason here is how 

```
#######################
## Create AWS config ##
#######################


mkdir ~/.aws; \
cat << 'EOF' > ~/.aws/config
[profile s3-role]
role_arn = arn:aws:iam::683290208331:role/s3-mojo-file-transfer-assume-role
credential_source = Ec2InstanceMetadata
EOF
```

now test with the following aws cli command

```
aws sts get-caller-identity
```

then access to the s3 bucket

```
aws s3 ls s3://mojo-file-transfer/ --profile s3-role
```



from another terminal window in the root of the project run

## Get a DB dump

In order to connect to the database the following items will be needed.

- fqdn e.g. `"fqdn": "dhcp-dns-admin-dhcp-db.dev.staff.service.justice.gov.uk",`
- username e.g. `"username": "adminuser"`
- password

### Retrieve connection details

Connection strings for testing connectivity and accessing the DBs are described below, however you can obtain ready baked dynamically created versions by running:

```shell
make rds-admin
```

or

```shell
make rds-server
```

To get the password run

```shell
make rds-admin-password
```

or

```shell
make rds-server-password
```

A  file will be created and shown on the terminal with all the correct details retrieved from Terraform outputs for the environment. You can view that file at any time it will be named `.db_connection.{ENV}.admin|server`.

```shell
cat .db_connection.{ENV}.admin
```

### Test connection

```shell
fqdn=dhcp-dns-admin-db.dev.staff.service.justice.gov.uk && curl -v telnet://${fqdn}:3306 --output rds.txt
```

### Connect to DB

```shell
fqdn=dhcp-dns-admin-db.dev.staff.service.justice.gov.uk
admin_db_username=adminuser
mysql -u ${admin_db_username} -p -h ${fqdn}

## enter password when prompted
Enter password:
```

You should see the MySQL command prompt.

```shell
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 80936
Server version: 5.7.42-log Source distribution

Copyright (c) 2000, 2023, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

Run some SQL queries to identify the database name etc.

### which databases?

```sql
mysql>
show databases;
```

### Use the database and see the table names

```sql
mysql>
use staffdevicedevelopmentdhcpadmin;
show tables;
```

### Get a DB dump

Create a timestamped database dump and upload it to S3 transfer bucket (copy and paste from your local `.db_connection.{env}.admin` file).

Example below for illustration only.
```shell
env="DEVELOPMENT"; \
db_name="staffdevicedevelopmentdhcpadmin"; \
filename="`date "+%Y_%m_%d-%H_%M_%S"`_${env}_${db_name}_rds-dump.sql"; \
fqdn="dhcp-dns-admin-db.dev.staff.service.justice.gov.uk"; \
admin_db_username="adminuser"; \
mysqldump \
	-u "${admin_db_username}" \
	-p \
	--set-gtid-purged=OFF \
	--triggers --routines --events \
	-h "${fqdn}"  \
	"${db_name}" > ~/${filename}; \
	ls -al; \
aws s3 cp ~/${filename} s3://mojo-file-transfer/ --profile s3-role; \
aws s3 ls s3://mojo-file-transfer/ --profile s3-role;
```

## Removal

Set the boolean value in parameter store to `false`
run the pipeline
