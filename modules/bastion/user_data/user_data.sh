#!/usr/bin/env bash
set -x

mkdir ~/.aws
cat << 'EOF' > ~/.aws/config
[profile s3-role]
role_arn = arn:aws:iam::683290208331:role/s3-mojo-file-transfer-assume-role
credential_source = Ec2InstanceMetadata
EOF
