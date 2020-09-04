output "terraform_outputs" {
  value = {
    ecs = {
      dhcp_cluster_name = module.dhcp.dhcp_cluster_name
    }
  }
}
