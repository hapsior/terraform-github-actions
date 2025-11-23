# Configure the Azure AD Application for GitHub OIDC - I could do it manually but why not automate it with Terraform

data "azurerm_client_config" "current" {}

# Create an Azure AD application registration
# This represents the GitHub Actions OIDC identity in Azure AD
resource "azuread_application_registration" "github_oidc" {
  display_name = "github-oidc-connection-for-tf"
}

# Create a Service Principal for the Azure AD application
# The Service Principal is used to authenticate Terraform to Azure
resource "azuread_service_principal" "github_oidc_sp" {
  client_id = azuread_application_registration.github_oidc.client_id
}

# Create a federated identity credential for OIDC
# This allows GitHub Actions to authenticate to Azure using OIDC tokens
resource "azuread_application_federated_identity_credential" "github_oidc" {
  application_id = azuread_application_registration.github_oidc.id
  display_name   = "oidc-cred-hapsior-terraform-github-actions"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:hapsior/terraform-github-actions:ref:refs/heads/*"
}

data "azurerm_subscription" "current" {}

# Assign the Contributor role to the Service Principal in the subscription
# This gives the SP permissions to manage resources in the subscription
resource "azurerm_role_assignment" "github_oidc_sp_contributor" {
  principal_id         = azuread_service_principal.github_oidc_sp.object_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_subscription.current.id
}

resource "azurerm_resource_group" "rg-test" {
  name     = "rg-${var.application_name}-${var.environment_name}-test"
  location = var.primary_location
}
