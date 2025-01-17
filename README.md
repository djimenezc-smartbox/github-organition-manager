# github-organization-manager

Code to manage repositories of your GitHub organization

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
        <li><a href="#architecture">Architecture</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li>
        <a href="#ci/cd">CI/CD</a>
        <ul>
            <li><a href="#ci">CI</a></li>
            <li><a href="#terraform-apply">Terraform Apply</a></li>
        </ul>
    </li>
    <li><a href="#links">Links</a></li>
  </ol>
</details>

## About The Project

As an organisation, we are currently managing all our code repositories manually within our GitHub account. Over time the configuration of each repository has changed at different times, leading to a significant variance in how each repository is set up.

Therefore, we were leaded to use Infrastructure-as-code approach to ensure repositories are configured consistently giving the ability to add a new repository quickly and easily within our GitHub Organisation

Additionally, we would like to use the opportunity to more clearly manage the users that have access to our repositories and make it easy to add and remove them from the GitHub Organisation.

### Built With

I think nowadays the best tool in the market to manage a GitHub organization and cloud infrastructure in general is Terraform.

Terraform is an open-source IaC solution created by HashiCorp and primarily employed by DevOps teams.

The most outstanding features to pick up Terraform are:

- Provider Agnostic
- Modularity
- Version Control Capabilities

To provision new resources in GitHub we are taking advantage of the [GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs)

The GitHub provider offers multiple ways to authenticate with GitHub API.

The best idea to authenticate our process against GitHub API is installing a GitHub App because we do associate the authentication method to the organization making it independent of any user. 

```terraform
provider "github" {
  owner = var.github_organization
  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file(var.github_app_pem_file_path)
  }
}
```

The information is fetched from your organization Settings page. Firstly you should have set up a GitHub App as indicated in this article [Authenticating Terraform With a GitHub App](https://solideogloria.tech/terraform/authenticating-terraform-with-a-github-app/)

To pass the values in the Terraform variables just define the following env variables:

- github_app_id
- github_app_installation_id
- github_app_pem_file

It has been decided to create two TF modules that can be reused in other projects, specifically to create repositories and teams. In the [main.tf](./terraform/main.tf) file you could find the logic to associate teams with specific permissions to each repository created.

To store the terraform state, it has been decided to use S3 backend. After evaluating Terraform Cloud I came to the conclusion S3 backend was quite superior and give us more flexibility to manage multiple organization configurations using the workspace feature. 

### Architecture

![img_3.png](./images/img_4.png)

## Getting Started

### Prerequisites

- Terraform 1.9.1
- GitHub App credentials
- AWS credentials (used to store TF remote state files)

## Usage

As primary backend to store states files we are going to user S3, it is necessary to create an AWS session, for example defining the env variables AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and AWS_DEFAULT_REGION:

When we hava access to AWS api from the command lines we could initialize the terraform project running the following command:

```shell
make terraform-init
```

The workspace is defined by the env variable SETTINGS. In this case we have chosen the name of our organization (voxsmart).

The settings to model our organization are defined in the file [voxsmart.tfvars](./terraform/voxsmart.tfvars) and contains the configuration of the repositories and the permissions:

- repositories: define the main properties of a repository and the team and the permission associated
- teams: define the list of teams in the organization and the username of the members

Now you could run the plan command to see the expected resources provisioned by terraform

```shell
make terraform-plan
```

or you could apply the changes directly running

```shell
make terraform-apply
```

By default, voxsmart.tfvars file is selected after running the plan or apply command. It is possible to switch to a different configuration setting the env variable SETTINGS up to a different file name.

## CI/CD

To test the changes before are merged into the main branch the repository has a ruleset which:

- Prevent the main branch to be deleted
- Require linear history
- Require a pull request before merging
- Block force pushes

[Main Ruleset](https://github.com/djimenezc-voxsmart/github-organization-manager/settings/rules/1131628)

The repository contains two pipelines:

### CI

We run terraform validate commands and run a terraform plan for branches included in PRs into main. Once the source code has been review and the CI pipeline has run successfully it is allowed to merge the changes. See here few example [PR](https://github.com/djimenezc-voxsmart/github-organization-manager/pull/4) and [Workflow Execution](https://github.com/djimenezc-voxsmart/github-organization-manager/actions/runs/9861123282/job/27228869401)

![img_1.png](./images/img_1.png)


![img.png](./images/img.png)

### Terraform Apply

The changes are applied automatically once are merged into the main branch and the user approve the issue created by the pipeline

![img_2.png](./images/img_2.png)

![img_3.png](./images/img_3.png)

## Links

- [Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [Terraform cloud](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate)
- [GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs)
- [Authenticating Terraform With a GitHub App](https://solideogloria.tech/terraform/authenticating-terraform-with-a-github-app/)
- [Authenticating as a GitHub App installation](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/authenticating-as-a-github-app-installation)
- [Manual Workflow Approval](https://github.com/marketplace/actions/manual-workflow-approval)
