resource "github_team" "teams" {
  for_each    = var.teams
  name        = each.key
  description = each.value.description
  privacy     = each.value.privacy
}

locals {
  team_members = flatten([
    for team_name, team in var.teams : [
      for member in team.members : [
        for team in github_team.teams : [
          merge(team, {
            username : member
          })
        ]
        if team_name == team.name
      ]
    ]
  ])
}

resource "github_team_membership" "some_team_membership" {
  for_each = { for idx, team in local.team_members : idx => team }
  team_id  = each.value.id
  username = each.value.username
  role     = "member"
}
