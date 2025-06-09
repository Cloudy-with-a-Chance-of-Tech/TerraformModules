variable "location" {
  description = "The Azure region where the resource group will be created."
  type        = string
  default     = "southcentralus"
}

variable "resource_group_name" {
  description = "The name of the resource group to create. If the name doesn't start with 'rg-', it will be automatically prepended."
  type        = string
  default     = "rg-default-name"

  validation {
    condition     = length(var.resource_group_name) > 0 && length(var.resource_group_name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters long."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.resource_group_name))
    error_message = "Resource group name can only contain alphanumeric characters, periods, underscores, hyphens, and parentheses."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource group."
  type        = map(string)
  default = {
    "ManagedBy" : "Terraform"
  }
}