terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = "terraform25574"
    container_name       = "tfstate"
    key                  = "prod.terraform.vaultstate"
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resource-group" {
  name     = var.resource-group-name
  location = "eastus"
}

resource "azurerm_virtual_network" "vaultnet" {
  name                = "vnet-vault-eastus"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.resource-group.location
  resource_group_name = azurerm_resource_group.resource-group.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-vault-eastus"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.vaultnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.KeyVault"]
}

resource "random_id" "vaultid" {
  keepers = {
    # Generate a new id when resource group is switched
    resource_group_name = "${azurerm_resource_group.resource-group.name}"
  }

  byte_length = 8
}

resource "azurerm_key_vault" "keyvault" {
  name                        = "kv${random_id.vaultid.dec}"
  location                    = azurerm_resource_group.resource-group.location
  resource_group_name         = azurerm_resource_group.resource-group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  network_acls {
    bypass                     = "AzureServices"
    default_action             = "Deny"
    ip_rules                   = ["97.81.190.21/32", "1.1.1.1/32", "64.233.185.0/24"]
    virtual_network_subnet_ids = ["${azurerm_subnet.subnet.id}"]
  }

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore"
    ]
  }
}
