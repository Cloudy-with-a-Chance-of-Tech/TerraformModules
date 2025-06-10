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
    condition     = azurerm_resource_group.this.location == "eastus"
    error_message = "Resource group location should match input"
  }
}

# Test with existing rg- prefix
run "test_existing_prefix_resource_group" {
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

# Test with custom tags
run "test_custom_tags_resource_group" {
  command = plan

  variables {
    resource_group_name = "test-tags"
    location            = "centralus"
    tags = {
      Environment = "Test"
      Project     = "TerraformModules"
      Owner       = "TestSuite"
      ManagedBy   = "Terraform"
    }
  }

  assert {
    condition     = azurerm_resource_group.this.tags["Environment"] == "Test"
    error_message = "Custom tags should be applied correctly"
  }

  assert {
    condition     = azurerm_resource_group.this.tags["ManagedBy"] == "Terraform"
    error_message = "ManagedBy tag should be preserved"
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
