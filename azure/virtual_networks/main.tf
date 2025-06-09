locals {
  # Ensure virtual network name starts with "vnet-"
  virtual_network_name = lower(startswith(var.virtual_network_name, "vnet-") ? var.virtual_network_name : "vnet-${var.virtual_network_name}")
}

resource "azurerm_virtual_network" "this" {
  name                = local.virtual_network_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null

  # Optional configurations
  bgp_community           = var.bgp_community
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes

  # DDoS protection plan configuration
  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  tags = var.tags
}
