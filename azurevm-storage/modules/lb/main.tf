resource "azurerm_lb" "lb" {
  name                = "${var.environment}-lb"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = var.public_ip_id
  }
}

resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "backend-pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "nic_association" {
  count                   = var.vm_count
  network_interface_id    = var.vm_nic_ids[count.index]
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
}

