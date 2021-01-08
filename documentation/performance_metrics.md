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

The configuration file is reloaded every 5 minutes to support self service from the [Admin Portal](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin).

The primary KEA instance publishes metrics every 10 seconds.

#### NOTE:
Subnets are all configured to /24 which contains 256 available IPs.
For the purposes of this test, a large subnet was created for this test to allow leasing many IPs.
The remote testing site was configured to have a /16 range, which gives 65,536 available IPs.

## How to run these tests

These tests are designed to run from a remote site to give a realistic indication of the current performance of the KEA DHCP server as it will be used in production.

To gain access to the remote testing instance, please follow the steps in the [Corsham Testing](./corsham-test.md) documentation.

The remote VM has perfdhcp installed and [scripts](https://kea.readthedocs.io/en/latest/man/perfdhcp.8.html) to run these tests.

## Traffic Generation

### PerfDHCP

Perfdhcp is the load testing tool used to request leases from KEA.

A total of 1000 requests are sent, emulating 1000 clients.
The rate flag was increased to find the limits.

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

### Test 1

50 leases per second

```
Running: perfdhcp -n 1000 -r 50 -R 50 -W 100000 -d 100000 10.180.80.4
Scenario: basic.
Multi-thread mode enabled.
***Rate statistics***
Rate: 49.8992 4-way exchanges/second, expected rate: 50

***Statistics for: DISCOVER-OFFER***
sent packets: 1005
received packets: 1004
drops: 1
drops ratio: 0.0995025 %
orphans: 0

min delay: 8.253 ms
avg delay: 13.751 ms
max delay: 260.850 ms
std deviation: 25.423 ms
collected packets: 0

***Statistics for: REQUEST-ACK***
sent packets: 1004
received packets: 1003
drops: 1
drops ratio: 0.100 %
orphans: 0

min delay: 19.098 ms
avg delay: 38.267 ms
max delay: 444.803 ms
std deviation: 43.944 ms
collected packets: 0

```

#### ECS 

#### RDS

#### NLB

### Test 2

100 leases per second

```
Running: perfdhcp -n 1000 -r 100 -R 100 -W 100000 -d 100000 10.180.80.4
Scenario: basic.
Multi-thread mode enabled.
***Rate statistics***
Rate: 99.4924 4-way exchanges/second, expected rate: 100

***Statistics for: DISCOVER-OFFER***
sent packets: 1010
received packets: 1009
drops: 1
drops ratio: 0.0990099 %
orphans: 0

min delay: 8.236 ms
avg delay: 11.983 ms
max delay: 202.205 ms
std deviation: 16.418 ms
collected packets: 0

***Statistics for: REQUEST-ACK***
sent packets: 1009
received packets: 1005
drops: 4
drops ratio: 0.396 %
orphans: 0

min delay: 13.782 ms
avg delay: 32.471 ms
max delay: 280.126 ms
std deviation: 21.081 ms
collected packets: 0

```

#### ECS 

#### RDS

#### NLB

### Test 2

200 leases per second
#### ECS 

#### RDS

#### NLB

## Conclusion

400 leases per second
#### ECS 

#### RDS

#### NLB

## Conclusion
