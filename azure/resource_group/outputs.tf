output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.this.id
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "The Azure region where the resource group is located"
  value       = azurerm_resource_group.this.location
}

output "tags" {
  description = "The tags assigned to the resource group"
  value       = azurerm_resource_group.this.tags
}