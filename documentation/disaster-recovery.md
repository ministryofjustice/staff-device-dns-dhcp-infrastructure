# Disaster Recovery

Any unplanned downtime needs to be addresses as quickly as possible to minimise disruption of the end user devices.

Below is a list of potential causes, how these errors will be raised as alarms and how to remediate them:

1. [Corrupt configuration file was published](#corrupt-configuration-file)
2. [Corrupt container was published](#corrupt-container-was-published)
3. [Bad infrastructure apply with Terraform](bad-infrastructure-apply-with-terraform)
4. [DHCP Subnet gets full](#dhcp-subnet-gets-full)
5. [Server is receiving more traffic than it can handle](#server-is-receiving-more-traffic-than-it-can-handle)
6. [AWS Availability Zone goes down](#aws-availability-zone-goes-down)
7. [Other AWS failures](#other-aws-failures)

## Corrupt configuration file

The [self service portal](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin) allows administrators to make changes to the DNS and DHCP services in production. DHCP will have more configuration update requirements than DNS due to the need to manage subnets.

Measures have been taken to validate the changes, using service specific tools.
This should prevent any corrupt configurations from being published.

#### DHCP 

The Kea API [config-test](https://kea.readthedocs.io/en/kea-1.6.2/api.html#ref-config-test) command is used to validate the configuration file.

#### DNS

Bind verifies the configuration using the [named-checkconf](https://bind9.readthedocs.io/en/v9_16_8/configuration.html) command.

While these tools have proven to be reliable, if any configuration error was to get through, it could lead to the new instance of the server failing to boot.

Grafana alarms are configured to go off in this situation.
The specific metrics that are being monitored to make this visible are:

1. Unhealthy host count
2. Running task count

Either of these alarms going off could indicate a bad configuration file was published.

To recover from this situation, a utitlity scripts exists that can be run to roll back to a perviously known good version. Please see [Staff Device DNS DHCP Disaster Recovery](https://github.com/ministryofjustice/staff-device-dns-dhcp-disaster-recovery)

## Dev pushes bad container

## Bad infrastructure apply

## Subnet gets full

## Server is receiving more traffic than it can handle

## AZ goes down and other AWS Failures
## Other AWS failures
