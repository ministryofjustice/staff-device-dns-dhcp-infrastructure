#!/usr/bin/env bash

# export PARAM=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
#     "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/assume_role" \
#     "/staff-device/dns/pdns/ips" \
#     "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/azure_federation_metadata_url" \
#     "/staff-device/dns-dhcp/$ENV/enable_load_testing" \
#     "/staff-device/dns-dhcp/$ENV/number_of_load_testing_nodes" \
#     "/staff-device/dns-dhcp/$ENV/enable_rds_admin_bastion" \
#     "/staff-device/dns-dhcp/$ENV/enable_rds_servers_bastion" \
#     --query Parameters)

# export PARAM2=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
#     "/staff-device/dns/pdns/ips_list" \
#     "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/critical_notification_recipients" \
#     "/codebuild/$ENV/vpn_hosted_zone_id" \
#     "/route53/$ENV/vpn_hosted_zone_domain" \
#     "/staff-device/dhcp/$ENV/transit_gateway_id" \
#     "/staff-device/dhcp/$ENV/transit_gateway_route_table_id" \
#     --query Parameters)

# export PARAM3=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
#     "/staff-device/dns/$ENV/load_balancer_private_ip_eu_west_2a" \
#     "/staff-device/dns/$ENV/load_balancer_private_ip_eu_west_2b" \
#     "/staff-device/dns/$ENV/dns_route53_resolver_ip_eu_west_2a" \
#     "/staff-device/dns/$ENV/dns_route53_resolver_ip_eu_west_2b" \
#     "/staff-device/admin/sentry_dsn" \
#     "/staff-device/corsham_testing/bastion_allowed_ingress_ip" \
#     "/staff-device/corsham_testing/bastion_allowed_egress_ip" \
#     --query Parameters)

# export PARAM4=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
#     "/staff-device/corsham_testing/corsham_vm_ip" \
#     "/staff-device/dns-dhcp/model_office_vm_ip" \
#     "/staff-device/$ENV/dhcp_egress_transit_gateway_routes" \
#     "/staff-device/dns/$ENV/public_ip_pool_id" \
#     "/staff-device/dns-dhcp/$ENV/enable_bastion" \
#     "/staff-device/dns-dhcp/admin/$ENV/allowed_ip_ranges" \
#     "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/assume_role" \
#     "/codebuild/staff_device_shared_services_account_id" \
#     --query Parameters)

# declare -A params

# params["assume_role"]="$(echo $PARAM | jq '.[] | select(.Name | test("assume_role")) | .Value' --raw-output)"
# params["pdns_ips"]="$(echo $PARAM | jq '.[] | select(.Name | test("dns/pdns/ips")) | .Value' --raw-output)"
# params["azure_federation_metadata_url"]="$(echo $PARAM | jq '.[] | select(.Name | test("azure_federation_metadata_url")) | .Value' --raw-output)"
# params["enable_load_testing"]="$(echo $PARAM | jq '.[] | select(.Name | test("enable_load_testing")) | .Value' --raw-output)"
# params["number_of_load_testing_nodes"]="$(echo $PARAM | jq '.[] | select(.Name | test("number_of_load_testing_nodes")) | .Value' --raw-output)"
# params["enable_rds_admin_bastion"]="$(echo $PARAM | jq '.[] | select(.Name | test("enable_rds_admin_bastion")) | .Value' --raw-output)"
# params["enable_rds_servers_bastion"]="$(echo $PARAM | jq '.[] | select(.Name | test("enable_rds_servers_bastion")) | .Value' --raw-output)"

# params["pdns_ips_list"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("dns/pdns/ips_list")) | .Value' --raw-output)"
# params["critical_notification_recipients"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("critical_notification_recipients")) | .Value' --raw-output)"
# params["vpn_hosted_zone_id"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("vpn_hosted_zone_id")) | .Value' --raw-output)"
# params["vpn_hosted_zone_domain"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("vpn_hosted_zone_domain")) | .Value' --raw-output)"
# params["dhcp_transit_gateway_id"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("transit_gateway_id")) | .Value' --raw-output)"
# params["transit_gateway_route_table_id"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("transit_gateway_route_table_id")) | .Value' --raw-output)"

# params["dns_load_balancer_private_ip_eu_west_2a"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("load_balancer_private_ip_eu_west_2a")) | .Value' --raw-output)"
# params["dns_load_balancer_private_ip_eu_west_2b"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("load_balancer_private_ip_eu_west_2b")) | .Value' --raw-output)"
# params["dns_route53_resolver_ip_eu_west_2a"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("dns_route53_resolver_ip_eu_west_2a")) | .Value' --raw-output)"
# params["dns_route53_resolver_ip_eu_west_2b"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("dns_route53_resolver_ip_eu_west_2b")) | .Value' --raw-output)"
# params["bastion_allowed_ingress_ip"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("bastion_allowed_ingress_ip")) | .Value' --raw-output)"
# params["bastion_allowed_egress_ip"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("bastion_allowed_egress_ip")) | .Value' --raw-output)"

# params["corsham_vm_ip"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("corsham_vm_ip")) | .Value' --raw-output)"
# params["model_office_vm_ip"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("model_office_vm_ip")) | .Value' --raw-output)"
# params["dhcp_egress_transit_gateway_routes"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("dhcp_egress_transit_gateway_routes")) | .Value' --raw-output)"
# params["byoip_pool_id"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("public_ip_pool_id")) | .Value' --raw-output)"
# params["enable_corsham_test_bastion"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("enable_bastion")) | .Value' --raw-output)"
# params["allowed_ip_ranges"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("allowed_ip_ranges")) | .Value' --raw-output)"
# params["ROLE_ARN"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("assume_role")) | .Value' --raw-output)"
# params["shared_services_account_id"]="$(echo $PARAM4 | jq '.[] | select(.Name | test("staff_device_shared_services_account_id")) | .Value' --raw-output)"
