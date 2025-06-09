# Azure Resource Group Module

This Terraform module creates an Azure Resource Group with configurable name, location, and tags.

## Features

- Creates an Azure Resource Group in a specified region
- Applies consistent tagging
- Converts resource group names to lowercase for consistency
- **Automatically prepends "rg-" prefix** if not already present in the name
- Validates resource group name format and length according to Azure requirements
- Provides comprehensive outputs for downstream module consumption

## Usage

### Using from Git Repository

```hcl
module "resource_group" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group"

  resource_group_name = "my-application-prod"  # Will become "rg-my-application-prod"
  location           = "East US"
  
  tags = {
    Environment = "Production"
    Project     = "MyApplication"
    Owner       = "Platform Team"
    ManagedBy   = "Terraform"
  }
}
```

### Using with Specific Version/Tag

```hcl
module "resource_group" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group?ref=v1.0.0"

  resource_group_name = "rg-my-application-prod"
  location           = "East US"
}
```

### Using with HTTPS (Alternative)

```hcl
module "resource_group" {
  source = "git::https://github.com/Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group"

  resource_group_name = "rg-my-application-prod"
  location           = "East US"
}
```

### Local Development Usage

```hcl
module "resource_group" {
  source = "./modules/azure/resource_group"

  resource_group_name = "rg-example"
  location           = "West US 2"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The Azure region where the resource group will be created. | `string` | `"southcentralus"` | no |
| resource_group_name | The name of the resource group to create. If the name doesn't start with 'rg-', it will be automatically prepended. | `string` | `"rg-default-name"` | no |
| tags | A map of tags to assign to the resource group. | `map(string)` | `{"ManagedBy": "Terraform"}` | no |

## Outputs

| Name | Description |
|------|-------------|
| location | The Azure region where the resource group is located |
| resource_group_id | The ID of the resource group |
| resource_group_name | The name of the resource group |
| tags | The tags assigned to the resource group |

## Examples

### Production Environment

```hcl
module "prod_rg" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group?ref=v1.0.0"

  resource_group_name = "myapp-prod"  # Will become "rg-myapp-prod"
  location           = "East US"
  
  tags = {
    Environment = "Production"
    Project     = "MyApplication"
    Owner       = "Platform Team"
    CostCenter  = "Engineering"
    ManagedBy   = "Terraform"
  }
}
```

### Development Environment

```hcl
module "dev_rg" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group"

  resource_group_name = "rg-myapp-dev"
  location           = "Central US"
  
  tags = {
    Environment = "Development"
    Project     = "MyApplication"
    Owner       = "Development Team"
    ManagedBy   = "Terraform"
  }
}
```

### Using Outputs in Other Modules

```hcl
module "resource_group" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group"

  resource_group_name = "rg-example"
  location           = "West US 2"
}

module "storage_account" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/storage_account"

  resource_group_name = module.resource_group.resource_group_name
  location           = module.resource_group.location
  tags               = module.resource_group.tags
}
```

## Notes

- Resource group names are automatically converted to lowercase for consistency
- **"rg-" prefix is automatically prepended** if not already present in the provided name
- The default location is set to "southcentralus" but should be overridden based on your requirements
- Default tags include "ManagedBy: Terraform" but can be extended or overridden
- This module follows Azure naming conventions and best practices
- Resource group names are validated for length (1-90 characters) and allowed characters

### Git Source Usage Notes

- **SSH Access**: The SSH Git source (`git@github.com:...`) requires SSH key authentication with GitHub
- **HTTPS Access**: Use the HTTPS Git source (`git::https://github.com/...`) if you prefer HTTPS authentication
- **Version Pinning**: It's recommended to pin to a specific version/tag in production (e.g., `?ref=v1.0.0`)
- **Branch Usage**: For development, you can use a specific branch (e.g., `?ref=main` or `?ref=develop`)
- **Path Specification**: The `//azure/resource_group` part specifies the subdirectory within the repository

### Version Management

When using this module from Git, consider:

1. **Production**: Always pin to a specific tag/version for stability
2. **Development**: Can use latest main branch for newest features
3. **Testing**: Use feature branches when testing new module versions

## Contributing

When contributing to this module, please ensure:

1. All variables have appropriate descriptions and types
2. All outputs have descriptions
3. Examples are updated if new functionality is added
4. README is kept up to date with any changes

## License

This module is open source and available in the [TerraformModules](https://github.com/Cloudy-with-a-Chance-of-Tech/TerraformModules) repository. Please follow the repository's license terms for usage and modification.