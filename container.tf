resource "random_uuid" "container-uuid" {
}

resource "azurerm_container_registry" "acrchallenge" {
  name                     = "acrchallenge${random_uuid.container-uuid.result}"
  resource_group_name      = azurerm_resource_group.resource-group.name
  location                 = azurerm_resource_group.resource-group.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["westeurope"]
}
