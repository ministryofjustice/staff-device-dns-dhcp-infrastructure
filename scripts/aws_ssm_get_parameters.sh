export PARAM=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/assume_role" \
    "/moj-network-access-control/$ENV/azure_federation_metadata_url" \
    "/moj-network-access-control/$ENV/hosted_zone_domain" \
    "/moj-network-access-control/$ENV/hosted_zone_id" \
    "/moj-network-access-control/$ENV/admin_db_username" \
    "/moj-network-access-control/$ENV/admin_db_password" \
    "/moj-network-access-control/$ENV/admin_sentry_dsn" \
    "/moj-network-access-control/$ENV/transit_gateway_id" \
    "/moj-network-access-control/$ENV/transit_gateway_route_table_id" \
    "/moj-network-access-control/$ENV/mojo_dns_ip_1" \
    --query Parameters)

export PARAM2=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/moj-network-access-control/$ENV/mojo_dns_ip_2" \
    "/moj-network-access-control/$ENV/ocsp/endpoint_ip" \
    "/moj-network-access-control/$ENV/ocsp/endpoint_port" \
    "/moj-network-access-control/$ENV/ocsp/atos/domain" \
    "/moj-network-access-control/$ENV/ocsp/atos/cidr_range_1" \
    "/moj-network-access-control/$ENV/ocsp/atos/cidr_range_2" \
    "/moj-network-access-control/$ENV/enable_ocsp" \
    "/moj-network-access-control/$ENV/ocsp_override_cert_url" \
    "/moj-network-access-control/$ENV/public_ip_pool_id" \
    "/moj-network-access-control/$ENV/eap_private_key_password" \
    --query Parameters)

export PARAM3=$(aws ssm get-parameters --region eu-west-2 --with-decryption --names \
    "/moj-network-access-control/$ENV/radsec_private_key_password" \
    "/moj-network-access-control/$ENV/debug/radius/enable_packet_capture" \
    "/moj-network-access-control/$ENV/debug/radius/packet_capture_duration_seconds" \
    "/moj-network-access-control/$ENV/cloudwatch_link" \
    "/moj-network-access-control/$ENV/grafana_dashboard_link" \
    "/moj-network-access-control/development/route53/ns_upsert" \
    "/moj-network-access-control/pre-production/route53/ns_upsert" \
    "/moj-network-access-control/$ENV/hosted_zone_id" \
    "/codebuild/pttp-ci-infrastructure-core-pipeline/$ENV/assume_role" \
    "/codebuild/staff_device_shared_services_account_id" \
    --query Parameters)

declare -A parameters


parameters["assume_role"]="$(echo $PARAM | jq '.[] | select(.Name | test("assume_role")) | .Value' --raw-output)"
parameters["azure_federation_metadata_url"]="$(echo $PARAM | jq '.[] | select(.Name | test("azure_federation_metadata_url")) | .Value' --raw-output)"
parameters["hosted_zone_domain"]="$(echo $PARAM | jq '.[] | select(.Name | test("hosted_zone_domain")) | .Value' --raw-output)"
parameters["hosted_zone_id"]="$(echo $PARAM | jq '.[] | select(.Name | test("hosted_zone_id")) | .Value' --raw-output)"
parameters["admin_db_username"]="$(echo $PARAM | jq '.[] | select(.Name | test("admin_db_username")) | .Value' --raw-output)"
parameters["admin_db_password"]="$(echo $PARAM | jq '.[] | select(.Name | test("admin_db_password")) | .Value' --raw-output)"
parameters["admin_sentry_dsn"]="$(echo $PARAM | jq '.[] | select(.Name | test("admin_sentry_dsn")) | .Value' --raw-output)"
parameters["transit_gateway_id"]="$(echo $PARAM | jq '.[] | select(.Name | test("transit_gateway_id")) | .Value' --raw-output)"
parameters["transit_gateway_route_table_id"]="$(echo $PARAM | jq '.[] | select(.Name | test("transit_gateway_route_table_id")) | .Value' --raw-output)"
parameters["mojo_dns_ip_1"]="$(echo $PARAM | jq '.[] | select(.Name | test("mojo_dns_ip_1")) | .Value' --raw-output)"

parameters["mojo_dns_ip_2"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("mojo_dns_ip_2")) | .Value' --raw-output)"
parameters["ocsp_endpoint_ip"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("ocsp/endpoint_ip")) | .Value' --raw-output)"
parameters["ocsp_endpoint_port"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("ocsp/endpoint_port")) | .Value' --raw-output)"
parameters["ocsp_atos_domain"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("ocsp/atos/domain")) | .Value' --raw-output)"
parameters["ocsp_atos_cidr_range_1"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("ocsp/atos/cidr_range_1")) | .Value' --raw-output)"
parameters["ocsp_atos_cidr_range_2"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("ocsp/atos/cidr_range_2")) | .Value' --raw-output)"
parameters["enable_ocsp"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("enable_ocsp")) | .Value' --raw-output)"
parameters["ocsp_override_cert_url"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("ocsp_override_cert_url")) | .Value' --raw-output)"
parameters["byoip_pool_id"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("public_ip_pool_id")) | .Value' --raw-output)"
parameters["eap_private_key_password"]="$(echo $PARAM2 | jq '.[] | select(.Name | test("eap_private_key_password")) | .Value' --raw-output)"

parameters["radsec_private_key_password"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("radsec_private_key_password")) | .Value' --raw-output)"
parameters["radius_enable_packet_capture"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("debug/radius/enable_packet_capture")) | .Value' --raw-output)"
parameters["packet_capture_duration_seconds"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("debug/radius/packet_capture_duration_seconds")) | .Value' --raw-output)"
parameters["cloudwatch_link"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("cloudwatch_link")) | .Value' --raw-output)"
parameters["grafana_dashboard_link"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("grafana_dashboard_link")) | .Value' --raw-output)"
parameters["DEVELOPMENT_ROUTE53_NS_UPSERT"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("development/route53/ns_upsert")) | .Value' --raw-output)"
parameters["PRE_PRODUCTION_ROUTE53_NS_UPSERT"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("pre-production/route53/ns_upsert")) | .Value' --raw-output)"
parameters["HOSTED_ZONE_ID"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("hosted_zone_id")) | .Value' --raw-output)"
parameters["ROLE_ARN"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("assume_role")) | .Value' --raw-output)"
parameters["shared_services_account_id"]="$(echo $PARAM3 | jq '.[] | select(.Name | test("staff_device_shared_services_account_id")) | .Value' --raw-output)"
