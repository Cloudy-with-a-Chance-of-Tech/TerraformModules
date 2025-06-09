provider "azurerm" {
  features {}
  skip_provider_registration = true
}

module "test_resource_group" {
  source = "../"

  resource_group_name = "test-minimal"
  location            = "eastus"
}

# Test outputs
output "resource_group_name" {
  value = module.test_resource_group.name
}

output "resource_group_id" {
  value = module.test_resource_group.id
}
