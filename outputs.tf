output "terraform_outputs" {
  value = {
    dhcp = {
      ecs = {
        module.dhcp.ecs
      }
    }
  }
}
