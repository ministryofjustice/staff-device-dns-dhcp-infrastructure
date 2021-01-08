# Performance metrics

This report presents a series of measurements on [Kea version 1.8](https://github.com/ministryofjustice/staff-device-dhcp-server/blob/main/dhcp-service/Dockerfile) run on [AWS infrastructure](./README.md).

To establish the upper bound on performance for KEA, a load test was conducted on the 8th of January 2021.

### KEA Configuration

KEA is running in hot-standby mode, with a Primary and Standby server. All traffic will be handled by Primary, and when it goes offline, the standby server will take over. The peer configuration is set up to send heartbeats between primary and standby, and to synchronise leases.

These tests were run with the production KEA configuration file loaded.

It has been configured with: 

- 142 Sites
- 829 Subnets 
- 14404 reservations 
- At least two client classes per subnet

KEA uses the MYSQL backend and has multi-threading enabled.

The configuration file is reloaded every 5 minutes.

The primary KEA instance publishes metrics every 10 seconds.

## How to run these tests

These tests are designed to run from a remote site to give a realistic indication of the current performance of the KEA DHCP server as it will be used in production.

To gain access to the remote testing instance, please follow the steps in the [Corsham Testing](./corsham-test.md) documentation.

The remote VM has perfdhcp installed and [scripts](https://kea.readthedocs.io/en/latest/man/perfdhcp.8.html) to run these tests.

## Traffic Generation

### PerfDHCP

Perfdhcp is the load testing tool used to request leases from KEA.

[Version 1.8.1](https://kea.readthedocs.io/en/latest/man/perfdhcp.8.html) was used to run this test.

Corsham

command 

TODO update with perf testing configs


### Hardware

#### ECS

KEA runs on ECS Fargate which is serverless and has the following resources:

- 2048 Memory
- 1024 CPU

#### RDS

The backend is a mysql database managed by AWS. There is only one database and no replication configured.

The database instance size is a [db.t2.large](https://aws.amazon.com/rds/instance-types/)

## Load test results 8th January 20201

### ECS 

#### CPU
#### Memory

### RDS

### NLB

## Conclusion
