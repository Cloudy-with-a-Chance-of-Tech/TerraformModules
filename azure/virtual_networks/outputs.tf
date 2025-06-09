output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.this.id
}

output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.this.name
}

output "location" {
  description = "The Azure region where the virtual network is located"
  value       = azurerm_virtual_network.this.location
}

output "resource_group_name" {
  description = "The name of the resource group containing the virtual network"
  value       = azurerm_virtual_network.this.resource_group_name
}

output "address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.this.address_space
}

output "dns_servers" {
  description = "The DNS servers configured for the virtual network"
  value       = azurerm_virtual_network.this.dns_servers
}

output "guid" {
  description = "The GUID of the virtual network"
  value       = azurerm_virtual_network.this.guid
}

output "subnet_ids" {
  description = "The IDs of subnets created within the virtual network (if any)"
  value       = azurerm_virtual_network.this.subnet
}

output "tags" {
  description = "The tags assigned to the virtual network"
  value       = azurerm_virtual_network.this.tags
}
