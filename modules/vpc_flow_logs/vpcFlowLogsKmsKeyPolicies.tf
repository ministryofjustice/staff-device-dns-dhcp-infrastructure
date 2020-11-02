data "template_file" "vpc_flow_logs_kms_key_policies" {
  template = file("${path.module}/policies/vpcFlowLogsKmsKeyPolicies.json")

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
    region         = var.region
  }
}
