resource "azurerm_resource_group" "ai_infra" {
  name     = var.resource_group_name
  location = var.location



}

resource "azurerm_virtual_network" "ai_vnet" {
  name                = "ai-vnet"
  location            = azurerm_resource_group.ai_infra.location
  resource_group_name = azurerm_resource_group.ai_infra.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "ai_subnet" {
  name                 = "ai-subnet"
  resource_group_name  = azurerm_resource_group.ai_infra.name
  virtual_network_name = azurerm_virtual_network.ai_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "ai_nsg" {
  name                = "ai-nsg"
  location            = azurerm_resource_group.ai_infra.location
  resource_group_name = azurerm_resource_group.ai_infra.name
}
