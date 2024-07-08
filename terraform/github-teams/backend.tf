terraform {
  required_version = ">= 1.9"
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "djimenezc"
#
#     workspaces {
#       name = "voxsmart"
#     }
#   }
}
