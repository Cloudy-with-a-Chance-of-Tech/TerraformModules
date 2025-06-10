# Provider configuration for tests
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  skip_provider_registration = true

  # Use service principal authentication from environment variables
  use_oidc = false
}

# Test with minimal configuration
run "test_minimal_virtual_network" {
  command = plan

  variables {
    resource_group_name  = "rg-vnet-test"
    virtual_network_name = "test-minimal"
    location             = "East US"
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-test-minimal"
    error_message = "Virtual network name should have 'vnet-' prefix prepended"
  }

  assert {
    condition     = contains(azurerm_virtual_network.this.address_space, "10.0.0.0/16")
    error_message = "Default address space should be 10.0.0.0/16"
  }
}

# Test with existing vnet- prefix
run "test_existing_prefix_virtual_network" {
  command = plan

  variables {
    resource_group_name  = "rg-vnet-test"
    virtual_network_name = "vnet-already-prefixed"
    location             = "East US"
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-already-prefixed"
    error_message = "Virtual network name should not double-prefix when 'vnet-' already exists"
  }
}

# Test with multiple address spaces
run "test_multiple_address_spaces" {
  command = plan

  variables {
    resource_group_name  = "rg-vnet-test"
    virtual_network_name = "test-multi-address"
    location             = "East US"
    address_space        = ["10.0.0.0/16", "172.16.0.0/16"]
  }

  assert {
    condition     = length(azurerm_virtual_network.this.address_space) == 2
    error_message = "Should support multiple address spaces"
  }

  assert {
    condition     = contains(azurerm_virtual_network.this.address_space, "10.0.0.0/16") && contains(azurerm_virtual_network.this.address_space, "172.16.0.0/16")
    error_message = "Should contain both specified address spaces"
  }
}

# Test with custom DNS servers
run "test_custom_dns_servers" {
  command = plan

  variables {
    resource_group_name  = "rg-vnet-test"
    virtual_network_name = "test-dns"
    location             = "East US"
    dns_servers          = ["10.0.0.4", "10.0.0.5"]
  }

  assert {
    condition     = length(azurerm_virtual_network.this.dns_servers) == 2
    error_message = "Should configure custom DNS servers"
  }

  assert {
    condition     = contains(azurerm_virtual_network.this.dns_servers, "10.0.0.4") && contains(azurerm_virtual_network.this.dns_servers, "10.0.0.5")
    error_message = "Should contain specified DNS servers"
  }
}

# Test uppercase conversion
run "test_uppercase_conversion" {
  command = plan

  variables {
    resource_group_name  = "rg-vnet-test"
    virtual_network_name = "TEST-UPPERCASE"
    location             = "East US"
  }

  assert {
    condition     = azurerm_virtual_network.this.name == "vnet-test-uppercase"
    error_message = "Virtual network name should be converted to lowercase"
  }
}
