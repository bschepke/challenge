resource "azurerm_resource_group" "rg-challenge-prod-1" {
  name     = "rg-challenge-prod-1"
  location = "East US"
}

resource "azurerm_container_registry" "acrchallengeprod1" {
  name                     = "acrchallengeprod1"
  resource_group_name      = azurerm_resource_group.rg-challenge-prod-1.name
  location                 = azurerm_resource_group.rg-challenge-prod-1.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["West Europe"]
}
