# Incorrect DNS Forwarder IPs
Date: 07-04-2021

## Incident Information

|  |  |
|:--- |:--- |
| Incident ID | INC1062330 |
| Incident Note | Unable to connect to secure sites - intranet |
| Impact | Access to HMPPS Intranet and PPUD sites for up to 280 users |
| Created Time | 07-04-2021 08:44 |
| Resolve Time | 07-04-2021 12:00 |
| Total Outage Time | 0 days 3 hrs 16 mins |

## Overview

On the morning of 07/04/2021 several calls were received from 08:44 about users not being able to access secure sites via their MOJ Official devices. This includes MOJ Intranet, PPUD, Nomis etc.

Investigation began into why those sites were not being resolved into respective IP addresses on internet browsers and it was identified that the MoJO DNS servers did not have correct DNS forwarders setup for the above mentioned sites.

After Cloud Ops team engaging with Networking team and Change Management team, two retrospective changes were approved and carried out immediately to update DNS Forwarders and relevant firewall routes. Changes were: 

 - CHG0047674 - PTTP - RETRO [INC1062330] PSN DNS entries updated  
 - CHG0047680 - PTTP - RETRO [INC1062330] PSN FW rule change for DNS

Once those two changes were carried out, the access to those affected sites was restored.

## Incident Detail

07-04-2021  
08:44 - First call was logged about user not being able to access Intranet sites.  
10:15 - Cloud Ops were notified on Slack channel  
10:30 - Troubleshooting began on MoJO Devices as well as on the DNS servers  
10:52 - It was discovered that DNS forwarders used on the DNS servers for those intranet sites were not updated in line with CHG0046551.  
11:00 - An urgent call was held between Cloud Ops, Networking, MIM and Change Management teams.
11:20 - Two retrospective changes were approved.

1. Update ‘MoJO DNS Services’ to use new DNS Servers – New IP’s – 51.33.255.42 and 51.33.255.58
1. Update the Palo Alto PSN VMs with the new DNS IP’s (above)

11:38 - Those two changes were carried out and service was restored.

## Root Cause of Incident

GCF DNS Servers had been decommissioned which were in use for external lookup, that meant we lost resolution on any DNS lookup within those zones held by GCF DNS servers. This will be a follow up element – to understand why MoJO was not aware of the GCF element.

## Summary and Recommendations

- Had to use Slack search to find the IPs that had changed. Can we manage a better discussion around changes that affect us / how do we know the source of truth
- Monitoring external DNS forwarders - this seems unmanageable when talking about all DNS forwarders managed by Staff Device DNS / DHCP admin
- Dependency mapping - when IPs change people need to know how this affects us equally our changes need to notify other interested parties
- Alerting based on increased rate of failed DNS requests (QrySERVFAIL for BIND)  

### Other findings

We noticed a spike in QrySERVFAIL errors during the incident and a spike in traffic to the DNS load balancer in the second availability zone. This is caused by failed DNS requests being sent to the secondary load balancer in the second AZ. 

We may want some alerting when the second AZ load balancer is used as it could be indidcative of an issue but in some cases this could also be expected behaviour.
 
