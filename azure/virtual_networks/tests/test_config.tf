# Test configuration file for virtual network module
# This file sets up the module call and outputs for testing

module "test_virtual_network" {
  source = "../"

  # Variables will be passed from the test cases
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers

  # Optional variables with defaults
  ddos_protection_plan = var.ddos_protection_plan
  bgp_community        = var.bgp_community
  edge_zone            = var.edge_zone
  tags                 = var.tags
}

# Variables that tests will provide
variable "name" {
  description = "Name of the virtual network"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "dns_servers" {
  description = "DNS servers"
  type        = list(string)
  default     = []
}

variable "ddos_protection_plan" {
  description = "DDoS protection plan"
  type = object({
    id     = string
    enable = bool
  })
  default = null
}

variable "bgp_community" {
  description = "BGP community"
  type        = string
  default     = null
}

variable "edge_zone" {
  description = "Edge zone"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}

# Outputs for testing assertions
output "virtual_network_name" {
  value = module.test_virtual_network.name
}

output "virtual_network_id" {
  value = module.test_virtual_network.id
}

output "virtual_network_address_space" {
  value = module.test_virtual_network.address_space
}

output "virtual_network_location" {
  value = module.test_virtual_network.location
}

output "virtual_network_resource_group_name" {
  value = module.test_virtual_network.resource_group_name
}
