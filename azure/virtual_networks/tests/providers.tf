# Provider configuration for testing
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Use environment variables for authentication:
  # ARM_SUBSCRIPTION_ID
  # ARM_CLIENT_ID
  # ARM_CLIENT_SECRET  
  # ARM_TENANT_ID

  # For local testing without credentials, you can skip provider registration
  skip_provider_registration = true
}
