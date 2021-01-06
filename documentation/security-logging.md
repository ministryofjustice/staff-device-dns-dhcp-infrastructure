# Security Logging

Logs from the DNS, DHCP and Admin portal are shipped to the MoJ Operation Security Team.

The cloudwatch log subscriptions are managed in the [logging infrastructure repository](https://github.com/ministryofjustice/staff-device-logging-infrastructure).

The logs that are shipped include:

- Admin Portal
- KEA Primary server logs
- KEA Standby server logs
- KEA API server logs

Log levels are set to INFO in production and can be managed through the admin portal here:

- [DNS](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin/blob/main/app/lib/use_cases/generate_bind_config.rb)
- [DHCP](https://github.com/ministryofjustice/staff-device-dns-dhcp-admin/blob/main/app/lib/use_cases/generate_kea_config.rb)

Setting these log levels to debug will generate a large volume of log data and may impact the performance of the DHCP and DNS servers.
