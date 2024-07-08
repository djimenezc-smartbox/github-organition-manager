provider "github" {
  owner = var.github_organization
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file(var.github_app_pem_file_path)
  }
}

module "github-organization" {
  source = "./github-organization"


}

resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"

  visibility = "private"

}
