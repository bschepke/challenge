resource "random_id" "container_id" {
  keepers = {
    # Generate a new id when resource group is switched
    resource_group_name = "${azurerm_resource_group.resource-group.name}"
  }

  byte_length = 8
}

resource "azurerm_container_registry" "acrchallenge" {
  name                     = "acrchallenge${random_id.container_id.dec}"
  resource_group_name      = azurerm_resource_group.resource-group.name
  location                 = azurerm_resource_group.resource-group.location
  sku                      = "Premium"
  admin_enabled            = false
  georeplication_locations = ["westeurope"]
}
