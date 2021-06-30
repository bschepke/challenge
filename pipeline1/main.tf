terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "terraform25574"
    container_name       = "tfstate"
    key                  = "prod.terraform.containerstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "resource-group" {
  name     = var.resource-group-name
  location = "eastus"
}

resource "random_id" "containerid" {
  keepers = {
    # Generate a new id when resource group is switched
    resource_group_name = "${azurerm_resource_group.resource-group.name}"
  }

  byte_length = 8
}

resource "azurerm_container_registry" "acrchallenge" {
  name                = "acrchallenge${random_id.containerid.dec}"
  resource_group_name = azurerm_resource_group.resource-group.name
  location            = azurerm_resource_group.resource-group.location
  sku                 = "Premium"
  admin_enabled       = false
  georeplications     = [{
    location = "westeurope"
    zone_redundancy_enabled = false
    tags = {}
  }]

  network_rule_set {
    default_action = "Deny"

    ip_rule {
      action   = "Allow"
      ip_range = "97.81.190.21/32"
    }

    ip_rule {
      action   = "Allow"
      ip_range = "1.1.1.1/32"
    }

    ip_rule {
      action   = "Allow"
      ip_range = "64.233.185.0/24"
    }
  }
}
