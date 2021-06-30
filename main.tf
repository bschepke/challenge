terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "terraform25574"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource-group" {
  name     = var.resource-group-name
  location = "eastus"
}
