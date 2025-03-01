variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "ai-infra-rg"
}

variable "location" {
  description = "Azure Region"
  type        = string
  default     = "East US"
}

variable "vm_name" {
  description = "Name of the GPU VM"
  type        = string
  default     = "gpu-training-vm"
}

variable "vm_size" {
  description = "GPU-enabled VM size"
  type        = string
  default     = "Standard_NC6s_v3"
}

variable "admin_username" {
  description = "Admin username for VM"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key" {
  description = "SSH Public Key for VM login"
  type        = string
}

