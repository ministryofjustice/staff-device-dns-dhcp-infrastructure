resource "aws_ecr_repository" "docker_dhcp_repository" {
  name                 = "docker_dhcp"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_ecr_authorization_token" "token" {
}
