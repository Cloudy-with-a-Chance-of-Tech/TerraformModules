# Test file for resource group module

# Test minimal configuration
run "test_minimal_resource_group" {
  command = plan

  variables {
    resource_group_name = "test-minimal"
    location            = "eastus"
  }

  assert {
    condition     = azurerm_resource_group.this.name == "rg-test-minimal"
    error_message = "Resource group name should have 'rg-' prefix prepended"
  }

  assert {
    condition     = azurerm_resource_group.this.location == "East US"
    error_message = "Resource group location should match input"
  }
}

# Test existing rg- prefix
run "test_existing_prefix" {
  command = plan

  variables {
    resource_group_name = "rg-already-prefixed"
    location            = "westus2"
  }

  assert {
    condition     = azurerm_resource_group.this.name == "rg-already-prefixed"
    error_message = "Resource group name should not double-prefix when 'rg-' already exists"
  }
}

# Test uppercase conversion
run "test_uppercase_conversion" {
  command = plan

  variables {
    resource_group_name = "TEST-UPPERCASE"
    location            = "southcentralus"
  }

  assert {
    condition     = azurerm_resource_group.this.name == "rg-test-uppercase"
    error_message = "Resource group name should be converted to lowercase"
  }
}
