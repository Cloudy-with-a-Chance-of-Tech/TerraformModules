# Windows Compute Module
# This module will create Windows virtual machines and related resources

# Placeholder for Windows compute resources
# TODO: Implement Windows VM, availability sets, load balancers, etc.

locals {
  # Naming convention - prepend vm- if not present and convert to lowercase
  vm_name = can(regex("^vm-", lower(var.name))) ? lower(var.name) : "vm-${lower(var.name)}"
}

# Data source for existing resource group
data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

# Placeholder resource (will be replaced with actual VM resources)
resource "azurerm_resource_group" "placeholder" {
  count    = 0 # This is a placeholder, count = 0 means it won't be created
  name     = "placeholder"
  location = var.location
}