output "terraform_outputs" {
  value = {
    ecs = module.dhcp.ecs
  }
}
