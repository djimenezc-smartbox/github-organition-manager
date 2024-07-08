provider "github" {
#   alias = "usw1"
  owner = var.github_organization
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file = file(var.github_app_pem_file_path)
  }
}

module "github-repositories" {
  source = "./github-repositories"

  github_organization = var.github_organization

  repositories = var.repositories

  providers = {
    github = github
  }
}

module "github-teams" {
  source = "./github-teams"

  teams = var.teams

  providers = {
    github = github
  }
}

locals {
  repository_permissions = flatten([
    for idx, repository in var.repositories : flatten([
      for team_permission in repository.team_permissions : {
        team_name : team_permission.team_name,
        repository_name : repository.name,
        permission : team_permission.permission
      }
    ])
  ])

  repository_team_relationship_tmp = [
    for team in module.github-teams.teams :
    merge({
      for repository in local.repository_permissions :
      "${repository.repository_name}-${team.name}" => {
        repo_name : repository.repository_name,
        team_name : team.name,
        team_id : team.id,
        permission : repository.permission
      }
      if repository.team_name == team.name
    })
  ]

  repository_team_relationship = merge([
    for repo_team in local.repository_team_relationship_tmp : repo_team
  ]...)
}

resource "github_team_repository" "some_team_repo" {
  for_each = local.repository_team_relationship
  team_id    = each.value.team_id
  repository = each.value.repo_name
  permission = each.value.permission
}
