resource "aws_autoscaling_group" "auto_scaling_group" {
  name                      = aws_launch_configuration.launch_configuration.name
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 2
  force_delete              = true
  placement_group           = aws_placement_group.placement_group.id
  launch_configuration      = aws_launch_configuration.launch_configuration.name
  vpc_zone_identifier       = var.subnets
  wait_for_capacity_timeout = "20m"

  tag {
    key                 = "AmazonECSManaged"
    value               = "AmazonECSManaged"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }
}

resource "aws_placement_group" "placement_group" {
  name     = "${var.prefix}-placement-group"
  strategy = "spread"

  tags = var.tags
}

resource "aws_launch_configuration" "launch_configuration" {
  name            = "${var.prefix}-server-launch-confguration"
  image_id      = data.aws_ami.server.id
  security_groups = [var.security_group_id]
  instance_type = "t2.medium"
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.id
  enable_monitoring = true
  user_data = <<DATA
Content-Type: multipart/mixed; boundary="==BOUNDARY=="
MIME-Version: 1.0

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/cloud-config; charset="us-ascii"
#cloud-config
repo_update: true
repo_upgrade: all

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
sudo yum install perl-Switch perl-DateTime perl-Sys-Syslog perl-LWP-Protocol-https -y
sudo yum -y install perl-Digest-SHA perl-URI perl-libwww-perl perl-MIME-tools perl-Crypt-SSLeay perl-XML-LibXML unzip
mkdir -p /home/ec2-user/scripts
cd /home/ec2-user/scripts
curl https://aws-cloudwatch.s3.amazonaws.com/downloads/CloudWatchMonitoringScripts-1.2.2.zip -O
unzip CloudWatchMonitoringScripts-1.2.2.zip
rm CloudWatchMonitoringScripts-1.2.2.zip
mv aws-scripts-mon /home/ec2-user/scripts/mon
amazon-linux-extras install nginx1.12 -y
service nginx start
cd /home/ec2-user/scripts/mon

EOF

sudo cp ./crontab /etc/crontab

cat <<'EOF' > ./security-updates
#!/bin/bash
sudo yum update -y --security
sudo yum update -y ecs-init
EOF

chmod +x ./security-updates
sudo cp ./security-updates /etc/cron.daily

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set cluster name

# NOTE: this cluster name cannot be inferred by Terraform, it ends up with a cycle error
# https://github.com/terraform-providers/terraform-provider-aws/issues/12739

echo ECS_CLUSTER=${var.prefix}-cluster >> /etc/ecs/ecs.config

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Install awslogs and the jq JSON parser
yum install -y awslogs jq

# Inject the CloudWatch Logs configuration file contents
cat > /etc/awslogs/awslogs.conf <<- EOF
[general]
state_file = /var/lib/awslogs/agent-state

[/var/log/dmesg]
file = /var/log/dmesg
log_group_name = /var/log/dmesg
log_stream_name = {cluster}/{container_instance_id}

[/var/log/messages]
file = /var/log/messages
log_group_name = /var/log/messages
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %b %d %H:%M:%S

[/var/log/docker]
file = /var/log/docker
log_group_name = /var/log/docker
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%S.%f

[/var/log/ecs/ecs-init.log]
file = /var/log/ecs/ecs-init.log.*
log_group_name = /var/log/ecs/ecs-init.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/ecs-agent.log]
file = /var/log/ecs/ecs-agent.log.*
log_group_name = /var/log/ecs/ecs-agent.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

[/var/log/ecs/audit.log]
file = /var/log/ecs/audit.log.*
log_group_name = /var/log/ecs/audit.log
log_stream_name = {cluster}/{container_instance_id}
datetime_format = %Y-%m-%dT%H:%M:%SZ

EOF

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/x-shellscript; charset="us-ascii"
#!/bin/bash
# Set the region to send CloudWatch Logs data to (the region where the container instance is located)
# region=$(curl 169.254.169.254/latest/meta-data/placement/availability-zone | sed s'/.$//')
region=eu-west-2
sed -i -e "s/region = us-east-1/region = $region/g" /etc/awslogs/awscli.conf

--==BOUNDARY==
MIME-Version: 1.0
Content-Type: text/upstart-job; charset="us-ascii"

#upstart-job
description "Configure and start CloudWatch Logs agent on Amazon ECS container instance"
author "Amazon Web Services"
start on started ecs

script
	exec 2>>/var/log/ecs/cloudwatch-logs-start.log
	set -x

	until curl -s http://localhost:51678/v1/metadata
	do
		sleep 1
	done

	# Grab the cluster and container instance ARN from instance metadata
	cluster=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .Cluster')
	container_instance_id=$(curl -s http://localhost:51678/v1/metadata | jq -r '. | .ContainerInstanceArn' | awk -F/ '{print $2}' )

	# Replace the cluster name and container instance ID placeholders with the actual values
	sed -i -e "s/{cluster}/$cluster/g" /etc/awslogs/awslogs.conf
	sed -i -e "s/{container_instance_id}/$container_instance_id/g" /etc/awslogs/awslogs.conf

	service awslogs start
	chkconfig awslogs on
end script
--==BOUNDARY==--

DATA

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "server" {
  most_recent      = true
  name_regex       = "^amzn-ami-.*-amazon-ecs-optimized$"
  owners           = ["amazon"]

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
