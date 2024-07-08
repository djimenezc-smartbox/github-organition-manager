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

  backend "s3" {
    key                  = "terraform.tfstate"
    workspace_key_prefix = "github-organization"
    region               = "eu-west-1"
    dynamodb_table       = "terraform-locks"
    encrypt              = true
  }
}
