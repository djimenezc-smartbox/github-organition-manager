provider "github" {
  alias  = "usw1"
  owner = var.github_organization
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file(var.github_app_pem_file_path)
  }
}

module "github-repositories" {
  source = "./github-repositories"

  github_organization = var.github_organization

  repositories = var.repositories

  providers = {
    github = github.usw1
  }
}

module "github-teams" {
  source = "./github-teams"

  teams = var.teams

  providers = {
    github = github.usw1
  }
}
