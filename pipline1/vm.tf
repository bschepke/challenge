resource "azurerm_virtual_network" "mynet" {
  name                = "myNet"
  address_space       = ["192.168.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.resource-group.name
}

resource "azurerm_subnet" "mysubnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.resource-group.name
  virtual_network_name = azurerm_virtual_network.mynet.name
  address_prefixes     = ["192.168.0.0/16"]
}

resource "azurerm_public_ip" "mypublicip" {
  name                = "publicIP"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.resource-group.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "mysecurity" {
  name                = "mysecurity"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.resource-group.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
