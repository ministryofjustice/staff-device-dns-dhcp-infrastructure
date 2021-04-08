# Incorrect DNS Forwarder IPs
Date: 07-04-2021

## What was the issue?

MoJo users lost access to PPUD and HMPPS intranet. DNS forwarders were pointing to servers which had been decommissioned at the end of March. This left certain DNS requests unable to resolve.


## How was the issue diagnosed

I could not reach DNS records forwarded to HMPPS / PPUD
From a MoJo device (or a bastion) ran an NsLookup for the DNS records
No response from the DNS forwarders (HMPPS / PPUD)
DNS was resolved for public DNS records (ie google.com)


## How was the issue resolved

Updated PPUD / HMPPS IP addresses in the Staff Device DNS / DHCP Admin Portal


## How can the issue be prevented from happening again

Had to use Slack search to find the IPs had changed (better discussion around changes that affect us / source of truth)
Monitoring external DNS forwarders
Dependency mapping - if IPs change people need to know how this affects us
Sanity checks for imported data - some of this data is outdated / incorrect

## Outstanding questions 

- Why did we not notice the change at the end of March?
