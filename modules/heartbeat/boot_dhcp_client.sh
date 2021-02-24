#!/bin/bash -x

apt-get update -y && apt-get install -y kea-admin

curl -o /root/amazon-cloudwatch-agent.deb https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E /root/amazon-cloudwatch-agent.deb

usermod -aG adm cwagent

touch /var/log/dhcp-heartbeat

mkdir -p /opt/aws/amazon-cloudwatch-agent/etc/
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "${log_file_path}",
            "log_group_name": "${log_group_name}",
            "log_stream_name": "{hostname}",
            "timestamp_format" :"%b %d %H:%M:%S"
          }
        ]
      }
    }
  }
}
EOF

systemctl enable amazon-cloudwatch-agent.service && service amazon-cloudwatch-agent start

while true; do
  perfdhcp -4 ${dhcp_ip} -n2 -r1 -d3 -R50000 | grep "received packets" >> ${log_file_path}
  sleep 10;
done
