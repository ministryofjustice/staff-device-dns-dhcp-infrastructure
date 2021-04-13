# Incorrect DNS Forwarder IPs
Date: 07-04-2021 8:30AM - 11:30AM approx

## What was the issue?

MoJo users lost access to PPUD and HMPPS intranet. DNS forwarders were pointing to servers which had been decommissioned at the end of March. This left certain DNS requests unable to resolve.


## How was the issue diagnosed

I could not reach DNS records forwarded to HMPPS / PPUD
From a MoJo device (or a bastion) ran an NsLookup for the DNS records
No response from the DNS forwarders (HMPPS / PPUD)
DNS was resolved for public DNS records (ie google.com)


## How was the issue resolved

Updated PPUD / HMPPS IP addresses in the Staff Device DNS / DHCP Admin Portal


## Other findings

We noticed a spike in QrySERVFAIL errors during the incident and a spike in traffic to the DNS load balancer in the second availability zone. This is caused by failed DNS requests being sent to the secondary load balancer in the second AZ. 

We may want some alerting when the second AZ load balancer is used as it could be indidcative of an issue but in some cases this could also be expected behaviour.

## How can the issue be prevented from happening again

- Had to use Slack search to find the IPs that had changed. Can we manage a better discussion around changes that affect us / how do we know the source of truth
- Monitoring external DNS forwarders - this seems unmanageable when talking about all DNS forwarders managed by Staff Device DNS / DHCP admin
- Dependency mapping - when IPs change people need to know how this affects us equally our changes need to notify other interested parties
- Sanity checks for imported data - some of this data is outdated / incorrect
- Alerting based on rate of change of QrySERVFAIL for BIND
 
## Outstanding questions 

- Why did we not notice the change at the end of March?
