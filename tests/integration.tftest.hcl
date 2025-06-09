# Integration test: Resource Group + Virtual Network
run "test_resource_group_and_virtual_network_integration" {
  command = plan

  module {
    source = "./azure/resource_group"
  }

  variables {
    resource_group_name = "integration-test"
    location            = "eastus"
    tags = {
      Environment = "Test"
      Purpose     = "Integration"
      ManagedBy   = "Terraform"
    }
  }
}

run "test_virtual_network_with_resource_group" {
  command = plan

  module {
    source = "./azure/virtual_networks"
  }

  variables {
    resource_group_name = run.test_resource_group_and_virtual_network_integration.resource_group_name
    name                = "integration-test"
    location            = run.test_resource_group_and_virtual_network_integration.location
    address_space       = ["10.100.0.0/16"]
    tags                = run.test_resource_group_and_virtual_network_integration.tags
  }

  assert {
    condition     = azurerm_virtual_network.this.resource_group_name == "rg-integration-test"
    error_message = "Virtual network should be created in the correct resource group"
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-integration-test"
    error_message = "Virtual network should have correct naming convention"
  }

  assert {
    condition     = azurerm_virtual_network.this.tags["Environment"] == "Test"
    error_message = "Tags should be inherited from resource group module"
  }
}
