# Terraform Module Testing Guide

## Overview
This document provides comprehensive guidance on testing Terraform modules using both local testing and CI/CD pipelines.

## Test Structure

### Local Testing
Our modules follow this testing structure:
```
azure/
├── resource_group/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── versions.tf
│   └── tests/
│       ├── providers.tf
│       ├── test_config.tf
│       └── resource_group.tftest.hcl
└── virtual_networks/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── versions.tf
    └── tests/
        ├── providers.tf
        ├── test_config.tf
        └── virtual_network.tftest.hcl
```

### Test Commands

#### Pre-requisites
1. Install Terraform (recommended version 1.6+)
   ```bash
   # On Windows with winget
   winget install HashiCorp.Terraform
   
   # On Linux/Mac with package manager
   sudo apt-get install terraform  # Ubuntu/Debian
   brew install terraform          # macOS
   ```

2. Configure Azure Authentication
   ```bash
   # Service Principal (recommended for CI/CD)
   export ARM_CLIENT_ID="your-client-id"
   export ARM_CLIENT_SECRET="your-client-secret" 
   export ARM_SUBSCRIPTION_ID="your-subscription-id"
   export ARM_TENANT_ID="your-tenant-id"
   
   # Or use Azure CLI
   az login
   ```

#### Running Tests Locally

1. **Format Check**
   ```bash
   cd azure/resource_group
   terraform fmt -check -recursive
   ```

2. **Initialize and Validate**
   ```bash
   terraform init
   terraform validate
   ```

3. **Run Native Terraform Tests**
   ```bash
   terraform test
   ```

4. **Run Manual Test Configuration**
   ```bash
   cd tests
   terraform init
   terraform plan
   terraform apply -auto-approve  # Only if you want to create real resources
   terraform destroy -auto-approve # Clean up
   ```

#### Security Scanning
```bash
# Install Checkov
pip install checkov

# Run security scan
checkov -d . --framework terraform
```

## CI/CD Pipeline Testing

### GitHub Actions
Our GitHub Actions workflow (`.github/workflows/terraform-tests.yml`) provides:

1. **Automated Validation**: Runs `terraform fmt`, `terraform init`, `terraform validate`
2. **Security Scanning**: Uses Checkov for static security analysis
3. **Test Execution**: Runs `terraform test` for each module
4. **Plan Generation**: Creates plans for pull requests
5. **Integration Tests**: Runs cross-module integration tests

### Azure DevOps
Our Azure DevOps pipeline (`azure-pipelines.yml`) provides:

1. **Multi-stage Pipeline**: Separate stages for validation, security, planning, and testing
2. **Matrix Strategy**: Parallel testing of multiple modules
3. **Security Integration**: Checkov scanning with results publishing
4. **Artifact Management**: Stores plans and security reports
5. **Notifications**: Teams integration for pipeline status

## Test Configuration Examples

### Resource Group Module Test
```hcl
# tests/resource_group.tftest.hcl
run "test_minimal_resource_group" {
  command = plan
  
  variables {
    resource_group_name = "test-minimal"
    location           = "eastus"
  }

  assert {
    condition     = azurerm_resource_group.this.name == "rg-test-minimal"
    error_message = "Resource group name should have 'rg-' prefix prepended"
  }
}
```

### Virtual Network Module Test
```hcl
# tests/virtual_network.tftest.hcl
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
}
```

## Pipeline Secrets Configuration

### GitHub Actions Secrets
Add these secrets to your GitHub repository:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`
- `TEAMS_WEBHOOK_URI` (optional)

### Azure DevOps Variables
Create a variable group named `terraform-secrets`:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET` (marked as secret)
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`
- `resourceGroupName`
- `storageAccountName`
- `containerName`

## Best Practices

1. **Test Isolation**: Each test should be independent
2. **Resource Naming**: Use consistent naming with module prefixes
3. **Cleanup**: Always clean up test resources in CI/CD
4. **Security**: Never commit secrets to version control
5. **Documentation**: Keep tests documented and maintainable

## Troubleshooting

### Common Issues
1. **Provider Authentication**: Ensure Azure credentials are properly configured
2. **Test Format**: Use proper HCL syntax in test files
3. **Resource Conflicts**: Use unique names to avoid conflicts
4. **Timeouts**: Increase timeouts for slow Azure operations

### Debugging Commands
```bash
# Verbose test output
terraform test -verbose

# Check provider configuration
terraform providers

# Validate configuration
terraform validate

# Debug authentication
az account show
```

## Integration with Git Repository

All modules are designed to be consumed from:
```
git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git
```

Usage example:
```hcl
module "resource_group" {
  source = "git@github.com:Cloudy-with-a-Chance-of-Tech/TerraformModules.git//azure/resource_group?ref=main"
  
  resource_group_name = "my-project"
  location           = "eastus"
  tags = {
    Environment = "Production"
    Project     = "MyApp"
  }
}
```
