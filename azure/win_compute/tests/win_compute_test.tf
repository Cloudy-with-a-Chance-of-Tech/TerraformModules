# Test configuration for Windows Compute module
# This is a test file for the Windows compute module

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

# Test the windows compute module
module "test_windows_vm" {
  source = "../"

  name                = "test-vm"
  resource_group_name = "test-rg"
  location            = "eastus"
  vm_size             = "Standard_B2s"
  admin_username      = "testuser"

  tags = {
    Environment = "Test"
    Purpose     = "Testing"
  }
}

# Output for validation
output "test_vm_name" {
  value = module.test_windows_vm.vm_name
}
