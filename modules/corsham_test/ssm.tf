resource "aws_ssm_parameter" "instance_private_key" {
  name        = "/corsham/testing/bastion/private_key"
  type        = "SecureString"
  value       = tls_private_key.ec2.private_key_pem
  overwrite   = true
  description = "SSH key for Corsham jumpbox"
  tags        = var.tags
}

resource "aws_ssm_parameter" "bastion_instance_ip" {
  name        = "/corsham/testing/bastion/ip"
  type        = "SecureString"
  value       = aws_instance.corsham_testing_bastion.public_ip
  overwrite   = true
  description = "IP address of the Bastion server"
  tags        = var.tags
}
