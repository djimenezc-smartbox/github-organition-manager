github_organization="djimenezc-voxsmart"

repositories = [
  {
    name: "voxsmart-service-api"
    description: "voxsmart service api"
    visibility: "private"
    has_issues: false
    has_projects: true
    has_discussions: true
    has_wiki: true
  },
  {
    name: "voxsmart-service-ui"
    description: "voxsmart service ui"
    visibility: "private"
    has_issues: true
    has_projects: true
    has_discussions: false
    has_wiki: false
  },
  {
    name: "voxsmart-service-sdk"
    description: "voxsmart service sdk"
    visibility: "public"
    has_issues: true
    has_projects: false
    has_discussions: true
    has_wiki: true
  }
]

teams = {
  frontend: {
    description: "Frontend team"
    privacy: "closed"
    members: [
      "djimenez-savi"
    ]
  },
  backend: {
    description: "Backend team"
    privacy: "closed"
    members: [
      "david-jimenez-calvo"
    ]
  }
}
