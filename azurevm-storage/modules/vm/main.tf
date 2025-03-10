resource "azurerm_network_interface" "vm_nic" {
  count               = var.vm_count
  name                = "${var.environment}-vm-${count.index + 1}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  count                 = var.vm_count
  name                  = "${var.environment}-vm-${count.index + 1}"
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm_nic[count.index].id]
  vm_size               = "Standard_B2s"

  storage_os_disk {
    name              = "${var.environment}-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.environment}-vm-${count.index + 1}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
