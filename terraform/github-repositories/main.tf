locals {
  repositories_map = { for idx, repo in var.repositories : idx => repo }
}

resource "github_repository" "example" {
  for_each = local.repositories_map

  name        = each.value.name
  description = each.value.description

  visibility = each.value.visibility

  has_issues      = each.value.has_issues
  has_projects    = each.value.has_projects
  has_discussions = each.value.has_discussions
  has_wiki        = each.value.has_wiki
}
