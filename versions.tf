terraform {
  required_version = ">= 1.1.8"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.75.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
    mysql = {
      source  = "terraform-providers/mysql"
      version = "~> 1.9"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}
