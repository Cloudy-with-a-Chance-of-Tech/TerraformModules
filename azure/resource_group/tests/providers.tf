# Test provider configuration
# This inherits from the root provider configuration but can override settings for testing

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  # Skip provider registration for faster testing
  skip_provider_registration = true
}
