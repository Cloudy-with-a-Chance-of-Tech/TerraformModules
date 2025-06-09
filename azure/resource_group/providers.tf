# Default provider configuration
# This can be overridden by consumers of the module
provider "azurerm" {
  features {}

  # For testing and development
  skip_provider_registration = true
}
