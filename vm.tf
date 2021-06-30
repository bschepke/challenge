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

resource "azurerm_network_interface" "mynic" {
  name                = "myNIC"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.resource-group.name

  ip_configuration {
    name                          = "myNicConfig"
    subnet_id                     = azurerm_subnet.mysubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mypublicip.id
  }
}

resource "azurerm_network_interface_security_group_association" "netassociation" {
  network_interface_id      = azurerm_network_interface.mynic.id
  network_security_group_id = azurerm_network_security_group.mysecurity.id
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

output "tls_private_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}

resource "azurerm_linux_virtual_machine" "myvm" {
  name                  = "myVM"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.resource-group.name
  network_interface_ids = [azurerm_network_interface.mynic.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "bailey"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "bailey"
    public_key = file("~/.ssh/id_rsa.pub")
  }
}
