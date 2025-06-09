variable "location" {
  description = "The Azure region where the virtual network will be created."
  type        = string
  default     = "southcentralus"
}

variable "resource_group_name" {
  description = "The name of the resource group where the virtual network will be created."
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters long."
  }
}

variable "virtual_network_name" {
  description = "The name of the virtual network to create. If the name doesn't start with 'vnet-', it will be automatically prepended."
  type        = string
  default     = "vnet-default-name"

  validation {
    condition     = length(var.virtual_network_name) > 0 && length(var.virtual_network_name) <= 64
    error_message = "Virtual network name must be between 1 and 64 characters long."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.virtual_network_name))
    error_message = "Virtual network name can only contain alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space."
  type        = list(string)
  default     = ["10.0.0.0/16"]

  validation {
    condition     = length(var.address_space) > 0
    error_message = "At least one address space must be provided."
  }
}

variable "dns_servers" {
  description = "List of IP addresses of DNS servers for the virtual network. If not specified, Azure's internal DNS will be used."
  type        = list(string)
  default     = []
}

variable "bgp_community" {
  description = "The BGP community attribute in format <as-number>:<community-value>."
  type        = string
  default     = null
}

variable "ddos_protection_plan" {
  description = "DDoS protection plan configuration."
  type = object({
    id     = string
    enable = bool
  })
  default = null
}

variable "edge_zone" {
  description = "Specifies the Edge Zone within the Azure Region where this Virtual Network should exist."
  type        = string
  default     = null
}

variable "flow_timeout_in_minutes" {
  description = "The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
  type        = number
  default     = null

  validation {
    condition     = var.flow_timeout_in_minutes == null || (var.flow_timeout_in_minutes >= 4 && var.flow_timeout_in_minutes <= 30)
    error_message = "Flow timeout must be between 4 and 30 minutes."
  }
}

variable "tags" {
  description = "A map of tags to assign to the virtual network."
  type        = map(string)
  default = {
    "ManagedBy" = "Terraform"
  }
}
