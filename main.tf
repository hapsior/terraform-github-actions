# Configure the Azure AD Application for GitHub OIDC - I could do it manually but why not automate it with Terraform

resource "azuread_application_registration" "github_oidc_app_registration" {
  display_name = "OIDC for GitHub Actions repo:hapsior/terraform-github-actions"
}

resource "azuread_application_federated_identity_credential" "github_oidc" {
  application_id = azuread_application_registration.github_oidc_app_registration.id
  display_name   = "oidc-cred-hapsior-terraform-github-actions"
  description    = "Deployments for GitHub"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:hapsior/terraform-github-actions:ref:refs/heads/*"
}
