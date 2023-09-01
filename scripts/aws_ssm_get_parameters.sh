export PARAM=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/assume_role" \
    "/staff-device/dns/pdns/ips" \
    "/staff-device/dns/pdns/ips_list" \
    "/codebuild/dhcp/$ENV/db/username" \
    "/codebuild/dhcp/$ENV/db/password" \
    --query Parameters)

export PARAM2=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/codebuild/dhcp/$ENV/admin/db/username" \
    "/codebuild/dhcp/$ENV/admin/db/password" \
    "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/azure_federation_metadata_url" \
    "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/critical_notification_recipients" \
    "/codebuild/$ENV/vpn_hosted_zone_id" \
    "/route53/$ENV/vpn_hosted_zone_domain" \
    "/staff-device/dhcp/$ENV/transit_gateway_id" \
    "/staff-device/dhcp/$ENV/transit_gateway_route_table_id" \
    "/staff-device/dhcp/$ENV/load_balancer_private_ip_eu_west_2a" \
    "/staff-device/dhcp/$ENV/load_balancer_private_ip_eu_west_2b" \
    --query Parameters)

export PARAM3=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/staff-device/dns/$ENV/load_balancer_private_ip_eu_west_2a" \
    "/staff-device/dns/$ENV/load_balancer_private_ip_eu_west_2b" \
    "/staff-device/dns/$ENV/dns_route53_resolver_ip_eu_west_2a" \
    "/staff-device/dns/$ENV/dns_route53_resolver_ip_eu_west_2b" \
    "/staff-device/admin/sentry_dsn" \
    "/staff-device/admin/$ENV/dns_private_zone" \
    "/staff-device/dhcp/sentry_dsn" \
    "/staff-device/dns/sentry_dsn" \
    "/staff-device/corsham_testing/bastion_allowed_ingress_ip" \
    "/staff-device/corsham_testing/bastion_allowed_egress_ip" \
    --query Parameters)

export PARAM4=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/staff-device/corsham_testing/corsham_vm_ip" \
    "/staff-device/dns-dhcp/model_office_vm_ip" \
    "/staff-device/$ENV/dhcp_egress_transit_gateway_routes" \
    "/staff-device/dns/$ENV/public_ip_pool_id" \
    "/staff-device/dns-dhcp/$ENV/enable_bastion" \
    "/staff-device/dns-dhcp/admin/$ENV/allowed_ip_ranges" \
    "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/assume_role" \
    "/codebuild/dhcp/admin/api/basic_auth_username" \
    "/codebuild/dhcp/admin/api/basic_auth_password" \
    "/codebuild/staff_device_shared_services_account_id" \
    --query Parameters)

declare -A parameters


parameters["assume_role"]="$(echo $PARAM | jq '.[] | select(.Name | test("assume_role")) | .Value' --raw-output)"
parameters["pdns_ips"]="$(echo $PARAM | jq '.[] | select(.Name | test("dns/pdns/ips")) | .Value' --raw-output)"
parameters["pdns_ips_list"]="$(echo $PARAM | jq '.[] | select(.Name | test("dns/pdns/ips_list")) | .Value' --raw-output)"
parameters["dhcp_db_username"]="$(echo $PARAM | jq '.[] | select(.Name | test("db/username")) | .Value' --raw-output)"
parameters["dhcp_db_password"]="$(echo $PARAM | jq '.[] | select(.Name | test("db/password")) | .Value' --raw-output)"

parameters["admin_db_username"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("admin/db/username")) | .Value' --raw-output)"
parameters["admin_db_password"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("admin/db/password")) | .Value' --raw-output)"
parameters["azure_federation_metadata_url"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("azure_federation_metadata_url")) | .Value' --raw-output)"
parameters["critical_notification_recipients"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("critical_notification_recipients")) | .Value' --raw-output)"
parameters["vpn_hosted_zone_id"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("vpn_hosted_zone_id")) | .Value' --raw-output)"
parameters["vpn_hosted_zone_domain"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("vpn_hosted_zone_domain")) | .Value' --raw-output)"
parameters["dhcp_transit_gateway_id"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("transit_gateway_id")) | .Value' --raw-output)"
parameters["transit_gateway_route_table_id"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("transit_gateway_route_table_id")) | .Value' --raw-output)"
parameters["dhcp_load_balancer_private_ip_eu_west_2a"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("load_balancer_private_ip_eu_west_2a")) | .Value' --raw-output)"
parameters["dhcp_load_balancer_private_ip_eu_west_2b"]="$(echo $PARAM1 | jq '.[] | select(.Name | test("load_balancer_private_ip_eu_west_2b")) | .Value' --raw-output)"

parameters["dns_load_balancer_private_ip_eu_west_2a"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("load_balancer_private_ip_eu_west_2a")) | .Value' --raw-output)"
parameters["dns_load_balancer_private_ip_eu_west_2b"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("load_balancer_private_ip_eu_west_2b")) | .Value' --raw-output)"
parameters["dns_route53_resolver_ip_eu_west_2a"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("dns_route53_resolver_ip_eu_west_2a")) | .Value' --raw-output)"
parameters["dns_route53_resolver_ip_eu_west_2b"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("dns_route53_resolver_ip_eu_west_2b")) | .Value' --raw-output)"
parameters["admin_sentry_dsn"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("admin/sentry_dsn")) | .Value' --raw-output)"
parameters["dns_private_zone"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("dns_private_zone")) | .Value' --raw-output)"
parameters["dhcp_sentry_dsn"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("dhcp/sentry_dsn")) | .Value' --raw-output)"
parameters["dns_sentry_dsn"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("dns/sentry_dsn")) | .Value' --raw-output)"
parameters["bastion_allowed_ingress_ip"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("bastion_allowed_ingress_ip")) | .Value' --raw-output)"
parameters["bastion_allowed_egress_ip"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("bastion_allowed_egress_ip")) | .Value' --raw-output)"

parameters["corsham_vm_ip"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("corsham_vm_ip")) | .Value' --raw-output)"
parameters["model_office_vm_ip"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("model_office_vm_ip")) | .Value' --raw-output)"
parameters["dhcp_egress_transit_gateway_routes"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("dhcp_egress_transit_gateway_routes")) | .Value' --raw-output)"
parameters["byoip_pool_id"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("public_ip_pool_id")) | .Value' --raw-output)"
parameters["enable_corsham_test_bastion"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("enable_bastion")) | .Value' --raw-output)"
parameters["allowed_ip_ranges"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("allowed_ip_ranges")) | .Value' --raw-output)"
parameters["ROLE_ARN"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("assume_role")) | .Value' --raw-output)"
parameters["api_basic_auth_username"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("basic_auth_username")) | .Value' --raw-output)"
parameters["api_basic_auth_password"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("basic_auth_password")) | .Value' --raw-output)"
parameters["shared_services_account_id"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("staff_device_shared_services_account_id")) | .Value' --raw-output)"
