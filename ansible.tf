resource "azurerm_resource_group" "RG1" {
  name     = "DevOps1"
  location = "East US"
}
# Create a vnet
resource "azurerm_virtual_network" "Vnet1" {
  name                = "Vnet1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name

}
# Create a subnet
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.Vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}
# Create public IPs
resource "azurerm_public_ip" "myip" {
  name                = "myPublicIP"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.RG1.name
  allocation_method   = "Dynamic"

}
# Create a NIC
resource "azurerm_network_interface" "Vnic1" {
  name                = "Vnic1"
  location            = azurerm_resource_group.RG1.location
  resource_group_name = azurerm_resource_group.RG1.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.myip.id
  }

}
# Create a VM
# Create SSH keys
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}
resource "azurerm_linux_virtual_machine" "RG1VM1" {
  name                  = "RG1VM2"
  resource_group_name   = azurerm_resource_group.RG1.name
  location              = azurerm_resource_group.RG1.location
  network_interface_ids = [azurerm_network_interface.Vnic1.id]
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
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }
  
  provisioner "local-exec" {
    command = "sleep 150"
  }
  provisioner "local-exec" {
    command = "ansible all -m shell -a 'yum -y install httpd'"
  }
  
}
resource "local_file" "hosts" {
    content  = azurerm_public_ip.myip.ip_address
    filename = "hosts"
  }