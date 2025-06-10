# Integration test: Resource Group + Virtual Network

# Provider configuration for integration tests
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

# First test the resource group module independently
run "test_resource_group_creation" {
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

  assert {
    condition     = output.resource_group_name == "rg-integration-test"
    error_message = "Resource group should follow naming convention: rg-integration-test"
  }

  assert {
    condition     = output.location == "eastus"
    error_message = "Resource group should be created in East US region"
  }

  assert {
    condition     = output.tags["Environment"] == "Test"
    error_message = "Resource group should have correct Environment tag"
  }
}

# Test the virtual network module independently  
run "test_virtual_network_integration" {
  command = plan

  module {
    source = "./azure/virtual_networks"
  }

  variables {
    resource_group_name    = "rg-integration-test"
    virtual_network_name   = "vnet-integration-test"
    location              = "eastus"
    address_space         = ["10.100.0.0/16"]
    tags = {
      Environment = "Test"
      Purpose     = "Integration"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = output.virtual_network_name == "vnet-integration-test"
    error_message = "Virtual network should follow naming convention: vnet-integration-test"
  }

  assert {
    condition     = output.resource_group_name == "rg-integration-test"
    error_message = "Virtual network should reference the correct resource group"
  }

  assert {
    condition     = contains(output.address_space, "10.100.0.0/16")
    error_message = "Virtual network should have the correct address space"
  }

  assert {
    condition     = output.tags["Environment"] == "Test"
    error_message = "Virtual network should have correct Environment tag"
  }
}
