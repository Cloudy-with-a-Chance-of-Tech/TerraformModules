# Azure Virtual Network Module

This Terraform module creates an Azure Virtual Network with configurable address spaces, DNS servers, and advanced networking features. Subnets are intentionally kept separate and should be managed using a dedicated subnet module.

## Features

- Creates an Azure Virtual Network in a specified region
- Applies consistent tagging
- Converts virtual network names to lowercase for consistency
- **Automatically prepends "vnet-" prefix** if not already present in the name
- Supports multiple address spaces and custom DNS servers
- Optional DDoS protection plan integration
- Optional BGP community configuration
- Edge zone support for enhanced performance
- Configurable flow timeout for connection tracking
- Validates virtual network name format and length according to Azure requirements
- Provides comprehensive outputs for downstream module consumption

## Usage

### Using from Git Repository

```hcl
module "virtual_network" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks"

  resource_group_name   = "rg-networking-prod"
  virtual_network_name  = "my-application-prod"  # Will become "vnet-my-application-prod"
  location             = "East US"
  address_space        = ["10.0.0.0/16"]
  
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
module "virtual_network" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks?ref=v1.0.0"

  resource_group_name   = "rg-networking-prod"
  virtual_network_name  = "my-application-prod"
  location             = "East US"
  address_space        = ["10.0.0.0/16"]
}
```

### Using with HTTPS (Alternative)

```hcl
module "virtual_network" {
  source = "git::https://github.com/Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks"

  resource_group_name   = "rg-networking-prod"
  virtual_network_name  = "my-application-prod"
  location             = "East US"
  address_space        = ["10.0.0.0/16"]
}
```

### Local Development Usage

```hcl
module "virtual_network" {
  source = "./modules/azure/virtual_networks"

  resource_group_name   = "rg-example"
  virtual_network_name  = "example"
  location             = "West US 2"
  address_space        = ["10.0.0.0/16"]
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
| [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The Azure region where the virtual network will be created. | `string` | `"southcentralus"` | no |
| resource_group_name | The name of the resource group where the virtual network will be created. | `string` | n/a | yes |
| virtual_network_name | The name of the virtual network to create. If the name doesn't start with 'vnet-', it will be automatically prepended. | `string` | `"vnet-default-name"` | no |
| address_space | The address space that is used by the virtual network. You can supply more than one address space. | `list(string)` | `["10.0.0.0/16"]` | no |
| dns_servers | List of IP addresses of DNS servers for the virtual network. If not specified, Azure's internal DNS will be used. | `list(string)` | `[]` | no |
| bgp_community | The BGP community attribute in format <as-number>:<community-value>. | `string` | `null` | no |
| ddos_protection_plan | DDoS protection plan configuration. | `object({id = string, enable = bool})` | `null` | no |
| edge_zone | Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. | `string` | `null` | no |
| flow_timeout_in_minutes | The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. | `number` | `null` | no |
| tags | A map of tags to assign to the virtual network. | `map(string)` | `{"ManagedBy": "Terraform"}` | no |

## Outputs

| Name | Description |
|------|-------------|
| virtual_network_id | The ID of the virtual network |
| virtual_network_name | The name of the virtual network |
| location | The Azure region where the virtual network is located |
| resource_group_name | The name of the resource group containing the virtual network |
| address_space | The address space of the virtual network |
| dns_servers | The DNS servers configured for the virtual network |
| guid | The GUID of the virtual network |
| subnet_ids | The IDs of subnets created within the virtual network (if any) |
| tags | The tags assigned to the virtual network |

## Examples

### Production Environment with Custom DNS

```hcl
module "prod_vnet" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks?ref=v1.0.0"

  resource_group_name   = "rg-networking-prod"
  virtual_network_name  = "myapp-prod"  # Will become "vnet-myapp-prod"
  location             = "East US"
  address_space        = ["10.0.0.0/16", "10.1.0.0/16"]
  dns_servers          = ["10.0.0.4", "10.0.0.5"]
  
  tags = {
    Environment = "Production"
    Project     = "MyApplication"
    Owner       = "Platform Team"
    CostCenter  = "Engineering"
    ManagedBy   = "Terraform"
  }
}
```

### Development Environment with Edge Zone

```hcl
module "dev_vnet" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks"

  resource_group_name   = "rg-networking-dev"
  virtual_network_name  = "myapp-dev"
  location             = "Central US"
  address_space        = ["172.16.0.0/16"]
  edge_zone            = "microsoftlosangeles1"
  
  tags = {
    Environment = "Development"
    Project     = "MyApplication"
    Owner       = "Development Team"
    ManagedBy   = "Terraform"
  }
}
```

### Enterprise Environment with DDoS Protection

```hcl
# First, create or reference a DDoS protection plan
resource "azurerm_network_ddos_protection_plan" "example" {
  name                = "ddos-protection-plan"
  location            = "East US"
  resource_group_name = "rg-security-prod"
}

module "enterprise_vnet" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks"

  resource_group_name   = "rg-networking-prod"
  virtual_network_name  = "enterprise-network"
  location             = "East US"
  address_space        = ["10.0.0.0/8"]
  flow_timeout_in_minutes = 20
  
  ddos_protection_plan = {
    id     = azurerm_network_ddos_protection_plan.example.id
    enable = true
  }
  
  tags = {
    Environment = "Production"
    Project     = "Enterprise"
    Owner       = "Security Team"
    Compliance  = "Required"
    ManagedBy   = "Terraform"
  }
}
```

### Using with Resource Group Module

```hcl
module "resource_group" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group"

  resource_group_name = "networking-example"
  location           = "West US 2"
}

module "virtual_network" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks"

  resource_group_name   = module.resource_group.resource_group_name
  virtual_network_name  = "example-network"
  location             = module.resource_group.location
  address_space        = ["192.168.0.0/16"]
  tags                 = module.resource_group.tags
}
```

### Hub and Spoke Architecture

```hcl
# Hub Virtual Network
module "hub_vnet" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks"

  resource_group_name   = "rg-networking-hub"
  virtual_network_name  = "hub"
  location             = "East US"
  address_space        = ["10.0.0.0/16"]
  dns_servers          = ["10.0.0.4", "10.0.0.5"]
  
  tags = {
    NetworkType = "Hub"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}

# Spoke Virtual Network
module "spoke_vnet" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/virtual_networks"

  resource_group_name   = "rg-networking-spoke"
  virtual_network_name  = "spoke-workloads"
  location             = "East US"
  address_space        = ["10.1.0.0/16"]
  
  tags = {
    NetworkType = "Spoke"
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

## Notes

- Virtual network names are automatically converted to lowercase for consistency
- **"vnet-" prefix is automatically prepended** if not already present in the provided name
- The default location is set to "southcentralus" but should be overridden based on your requirements
- Default tags include "ManagedBy: Terraform" but can be extended or overridden
- This module follows Azure naming conventions and best practices
- Virtual network names are validated for length (1-64 characters) and allowed characters
- **Subnets are intentionally not included** - use a separate subnet module for better modularity
- Flow timeout helps with connection tracking for intra-VM flows in scenarios requiring longer connections
- DDoS protection requires a separate DDoS protection plan resource

### Git Source Usage Notes

- **SSH Access**: The SSH Git source (`git@github.com:...`) requires SSH key authentication with GitHub
- **HTTPS Access**: Use the HTTPS Git source (`git::https://github.com/...`) if you prefer HTTPS authentication
- **Version Pinning**: It's recommended to pin to a specific version/tag in production (e.g., `?ref=v1.0.0`)
- **Branch Usage**: For development, you can use a specific branch (e.g., `?ref=main` or `?ref=develop`)
- **Path Specification**: The `//azure/virtual_networks` part specifies the subdirectory within the repository

### Version Management

When using this module from Git, consider:

1. **Production**: Always pin to a specific tag/version for stability
2. **Development**: Can use latest main branch for newest features
3. **Testing**: Use feature branches when testing new module versions

### Architecture Considerations

- **Address Space Planning**: Ensure address spaces don't overlap with other networks
- **DNS Configuration**: Use custom DNS servers for hybrid connectivity scenarios
- **DDoS Protection**: Consider enabling for production environments handling external traffic
- **Edge Zones**: Use for scenarios requiring ultra-low latency
- **BGP Communities**: Required for ExpressRoute scenarios with route filtering

## Contributing

When contributing to this module, please ensure:

1. All variables have appropriate descriptions and types
2. All outputs have descriptions
3. Examples are updated if new functionality is added
4. README is kept up to date with any changes
5. Validation rules are tested
6. New features include appropriate examples

## License

This module is open source and available in the [TerraformModules](https://github.com/Cloudy-with-a-Chance-of-Tech/TerraformModules) repository. Please follow the repository's license terms for usage and modification.
