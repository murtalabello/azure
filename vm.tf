resource "azurerm_public_ip" "ai_public_ip" {
  name                = "ai-public-ip"
  resource_group_name = azurerm_resource_group.ai_infra.name
  location            = azurerm_resource_group.ai_infra.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "ai_nic" {
  name                = "ai-nic"
  location            = azurerm_resource_group.ai_infra.location
  resource_group_name = azurerm_resource_group.ai_infra.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.ai_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ai_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "ai_vm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.ai_infra.name
  location            = azurerm_resource_group.ai_infra.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [azurerm_network_interface.ai_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "microsoft-dsvm"
    offer     = "ubuntu-hpc"
    sku       = "18_04-lts-gen2"
    version   = "latest"
  }
}
