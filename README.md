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
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#ci/cd">CI/CD</a></li>
  </ol>
</details>

## About The Project

As an organisation, we are currently managing all our code repositories manually within our GitHub account. Over time the configuration of each repository has changed at different times, leading to a significant variance in how each repository is set up.

Therefore, we were leaded to use Infrastructure-as-code approach to ensure repositories are configured consistently giving the ability to add a new repository quickly and easily within our GitHub Organisation

Additionally, we would like to use the opportunity to more clearly manage the users that have access to our repositories and make it easy to add and remove them from the GitHub Organisation.

### Built With

I think nowadays the best tool in the market to manage a GitHub organization and cloud infrastructure in general is Terraform.

Terraform is an open-source IaC solution created by HashiCorp and primarily employed by DevOps teams.

Te most outstanding features to pick up Terraform are:

- Provider Agnostic
- Modularity
- Version Control Capabilities

To provision new resources in GitHub we are taking advantage of the [GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs)

The GitHub provider offers multiple ways to authenticate with GitHub API.

The best idea to authenticate our process against GitHub API is installing a GitHub App 

```terraform

```

## Getting Started

### Prerequisites

### Installation

## Usage

As primary backend to store states files we are going to user Terraform cloud, it is necessary to log in to app.terraform.io running the following command:

```shell
make terraform-login
```

As a second step you need to initialize the terraform project running the following command:

```shell
make terraform-init
```

Using terraform cloud we need to specify the workspace name as part of the terraform configuration. In this case we have chosen the name of our organization (SmartBox).

The settings to model our organization are defined in the file smartbox.tfvars.




## CI/CD

## Links

- [Backend Configuration](https://developer.hashicorp.com/terraform/language/settings/backends/configuration)
- [Terraform cloud](https://developer.hashicorp.com/terraform/tutorials/cloud/cloud-migrate)
- [GitHub Provider](https://registry.terraform.io/providers/integrations/github/latest/docs)
- [Authenticating Terraform With a GitHub App](https://solideogloria.tech/terraform/authenticating-terraform-with-a-github-app/)
