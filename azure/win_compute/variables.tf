# Variables for Windows Compute Module

variable "name" {
  description = "Name for the Windows VM (prefix 'vm-' will be added automatically if not present)"
  type        = string
  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 60
    error_message = "Name must be between 1 and 60 characters."
  }
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.name))
    error_message = "Name can only contain alphanumeric characters and hyphens."
  }
}

variable "resource_group_name" {
  description = "Name of the existing resource group where the VM will be created"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty."
  }
}

variable "location" {
  description = "Azure region where the VM will be created"
  type        = string
  validation {
    condition     = length(var.location) > 0
    error_message = "Location cannot be empty."
  }
}

variable "vm_size" {
  description = "Size of the Windows VM"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username for the Windows VM"
  type        = string
  default     = "azureuser"
  validation {
    condition     = length(var.admin_username) >= 1 && length(var.admin_username) <= 20
    error_message = "Admin username must be between 1 and 20 characters."
  }
}

variable "admin_password" {
  description = "Administrator password for the Windows VM (use Azure Key Vault in production)"
  type        = string
  default     = null
  sensitive   = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}