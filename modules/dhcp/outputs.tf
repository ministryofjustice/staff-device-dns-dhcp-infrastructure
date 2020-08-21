output "aws_ecs_cluster_name" {
    value = aws_ecs_cluster.server_cluster.name
}

output "rds_identifier" {
    value = aws_db_instance.dhcp_server_db.id
}

output "load_balancer" {
    value = aws_lb.load_balancer.id
}

output "kea_config_bucket_arn" {
    value = aws_s3_bucket.config_bucket.arn
}

output "kea_config_bucket_name" {
  value = aws_s3_bucket.config_bucket.id
}

output "ssh_keypair_name" {
  value = aws_key_pair.bastion_public_key_pair.key_name
}

resource "local_file" "ec2_private_key" {
  filename          = "ec2.pem"
  file_permission   = "0600"
  sensitive_content = tls_private_key.ec2.private_key_pem
}

output "ssh_private_key" {
  value = tls_private_key.ec2.private_key_pem
}

