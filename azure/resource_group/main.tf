locals {
  # Ensure resource group name starts with "rg-"
  resource_group_name = lower(startswith(var.resource_group_name, "rg-") ? var.resource_group_name : "rg-${var.resource_group_name}")
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
  tags     = var.tags
}