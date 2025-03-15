provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "aks-rg"
  location = "East US"
}

module "storage" {
  source               = "./modules/storage"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  #count = 0 
}

module "dev_vm" {
  source               = "./modules/vm"
  environment          = "dev"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  vm_count             = 2
  subnet_id            = "<DEV_SUBNET_ID>"
  admin_username       = "adminuser"
  admin_password       = "SecurePass123!"
}

module "stage_vm" {
  source               = "./modules/vm"
  environment          = "stage"
  resource_group_name  = azurerm_resource_group.rg.name
  location             = azurerm_resource_group.rg.location
  vm_count             = 2
  subnet_id            = "<STAGE_SUBNET_ID>"
  admin_username       = "adminuser"
  admin_password       = "SecurePass123!"
}

module "dev_lb" {
  source              = "./modules/lb"
  environment         = "dev"
  resource_group_name = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  public_ip_id       = "<DEV_LB_PUBLIC_IP_ID>"
  vm_nic_ids         = module.dev_vm.vm_nic_ids
  vm_count           = 2
}

module "stage_lb" {
  source              = "./modules/lb"
  environment         = "stage"
  resource_group_name = azurerm_resource_group.rg.name
  location           = azurerm_resource_group.rg.location
  public_ip_id       = "<STAGE_LB_PUBLIC_IP_ID>"
  vm_nic_ids         = module.stage_vm.vm_nic_ids
  vm_count           = 2
}
