terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-obervability-dev"
    storage_account_name = "dhstdev"
    container_name       = "tfstate"
    key                  = "devops-dev"
  }

}

provider "azurerm" {
  features {}
  use_oidc = true
}

provider "azuread" {
  use_oidc = true
}
