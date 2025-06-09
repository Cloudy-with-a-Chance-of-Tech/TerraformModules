# Outputs for Windows Compute Module

output "vm_name" {
  description = "Name of the Windows VM (with prefix applied)"
  value       = local.vm_name
}

output "resource_group_name" {
  description = "Name of the resource group containing the VM"
  value       = var.resource_group_name
}

output "location" {
  description = "Azure region where the VM is located"
  value       = var.location
}

# Placeholder outputs for future VM resources
output "vm_id" {
  description = "ID of the Windows VM (placeholder)"
  value       = null
}

output "private_ip_address" {
  description = "Private IP address of the Windows VM (placeholder)"
  value       = null
}

output "public_ip_address" {
  description = "Public IP address of the Windows VM (placeholder)"
  value       = null
}