# output "team_members" {
#   value = module.github-teams.team_members
# }

# output "repository_team_relationship_tmp" {
#   value = local.repository_team_relationship_tmp
# }
output "repository_team_relationship" {
  value = local.repository_team_relationship
}

output "repository_permissions" {
  value = local.repository_permissions
}

# output "teams" {
#   value = module.github-teams.teams
# }
