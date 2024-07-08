variable "github_organization" {}

variable "repositories"{
  type = list(object({
    name: string
    description: string
    visibility: string
    has_issues: bool
    has_projects: bool
    has_discussions: bool
    has_wiki: bool,
    team_permissions: list(object({
      team_name: string
      permission: string
    }))
  }))
}
