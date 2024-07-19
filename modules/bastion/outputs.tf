output "bastion" {
  value = aws_instance.bastion[*].id
}
