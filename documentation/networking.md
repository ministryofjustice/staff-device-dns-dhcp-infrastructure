# Networking

## DNS / DHCP

The [DNS](https://github.com/ministryofjustice/staff-device-dns-server) and [DHCP](https://github.com/ministryofjustice/staff-device-dhcp-server) services are designed to be internal and not publicly accessible.
They integrate with the [Transit Gateway](https://aws.amazon.com/transit-gateway/) to gain access to the internal MoJ network.

The [VPC](https://aws.amazon.com/vpc/) is composed of both private and public subnets, with the services running in the private subnets.

Internet bound requests for resolving DNS queries to external servers depend on a [NAT gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) to send the request and to assign a static IP address from the [BYOIP](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-byoip.html) pool.

This is required as requests are only accepted from whitelisted sources. Specific routes are set up in the subnets to achieve this.

[VPC endpoints](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-endpoints.html) are set up to allow access to the following AWS services:

- [RDS](https://aws.amazon.com/rds/)
- [ECR](https://aws.amazon.com/ecr/)
- [Cloudwatch logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html)
- [Cloudwatch metrics](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/working_with_metrics.html)
- [S3](https://aws.amazon.com/s3/)

The internal Network Load balancers have static private IPs assigned to them. These are shared with remote sites to use the DHCP and DNS services.

## Admin Portal

The admin portal is internet facing and runs in public subnets.

To interact with the KEA API, running in a private subnet, a VPC endpoint is exposed with the [Network Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/network/introduction.html) as the destination.

The API is used to validate KEA configurations files and retrieve leases.
