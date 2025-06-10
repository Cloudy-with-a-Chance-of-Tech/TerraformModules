# Environment Setup Guide

This guide explains how to set up and use the multi-cloud environment configuration for local development and CI/CD pipelines.

## Quick Start

1. **Initial Setup**
   ```bash
   # Run the setup script
   ./scripts/setup-dev.sh
   
   # Or manually copy the example file
   cp .env.example .env
   ```

2. **Configure Your Credentials**
   Edit the `.env` file with your actual cloud provider credentials:
   ```bash
   # Edit the .env file with your credentials
   nano .env
   ```

3. **Validate Environment**
   ```bash
   # Check if everything is configured correctly
   make check-env
   
   # Load and validate environment variables
   make load-env
   ```

4. **Start Using Terraform**
   ```bash
   # Initialize Terraform
   make init
   
   # Plan changes
   make plan
   
   # Apply changes
   make apply
   ```

## File Structure

```
.
├── .env                    # Your local environment variables (DO NOT COMMIT)
├── .env.example           # Example environment file (safe to commit)
├── .gitignore            # Ensures .env files are not committed
├── Makefile              # Convenient commands for development
├── scripts/
│   ├── load-env.sh       # Load and validate local environment
│   ├── pipeline-env.sh   # Validate CI/CD environment
│   └── setup-dev.sh      # Initial development setup
└── .github/workflows/
    └── terraform.yml     # GitHub Actions workflow
```

## Environment Variables

### Azure Configuration
```bash
# Service Principal credentials
ARM_CLIENT_ID="your-azure-client-id"
ARM_CLIENT_SECRET="your-azure-client-secret"
ARM_SUBSCRIPTION_ID="your-azure-subscription-id"
ARM_TENANT_ID="your-azure-tenant-id"

# Azure settings
AZURE_LOCATION="East US"
AZURE_RESOURCE_GROUP="rg-terraform-dev"
AZURE_ENVIRONMENT="development"
```

### AWS Configuration (Optional)
```bash
# AWS credentials
AWS_ACCESS_KEY_ID="your-aws-access-key-id"
AWS_SECRET_ACCESS_KEY="your-aws-secret-access-key"
AWS_DEFAULT_REGION="us-east-1"
```

### Google Cloud Configuration (Optional)
```bash
# GCP service account
GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
GOOGLE_PROJECT="your-gcp-project-id"
GOOGLE_REGION="us-central1"
```

## Local Development

### Using Make Commands

The Makefile provides convenient commands for common operations:

```bash
# Environment management
make setup      # Initial setup (copy .env.example to .env)
make check-env  # Validate environment variables
make load-env   # Load and validate environment variables

# Terraform operations
make validate   # Validate Terraform configuration
make fmt        # Format Terraform files
make init       # Initialize Terraform
make plan       # Run Terraform plan
make apply      # Apply Terraform changes
make destroy    # Destroy Terraform resources
make clean      # Clean Terraform files

# Module-specific operations
make init-rg    # Initialize resource group module
make plan-vm    # Plan Windows compute module
make test-vnet  # Test virtual network module
```

### Manual Environment Loading

If you prefer not to use Make, you can manually load the environment:

```bash
# Load environment variables
source .env

# Or use the validation script
./scripts/load-env.sh

# Then run Terraform commands
terraform init
terraform plan
terraform apply
```

## CI/CD Pipeline Configuration

### GitHub Actions

The pipeline automatically:
1. Validates the environment (ensures no .env files are present)
2. Checks that required secrets are configured
3. Runs Terraform validation and tests
4. Performs security scanning with Checkov
5. Generates documentation

#### Required Secrets

Configure these secrets in your GitHub repository:

- `ARM_CLIENT_ID` - Azure Service Principal Client ID
- `ARM_CLIENT_SECRET` - Azure Service Principal Client Secret
- `ARM_SUBSCRIPTION_ID` - Azure Subscription ID
- `ARM_TENANT_ID` - Azure Tenant ID
- `AWS_ACCESS_KEY_ID` - AWS Access Key (optional)
- `AWS_SECRET_ACCESS_KEY` - AWS Secret Key (optional)
- `GOOGLE_CREDENTIALS` - GCP Service Account JSON (optional)

### Azure DevOps

The Azure Pipelines configuration includes:
1. Environment validation
2. Multi-module testing strategy
3. Security scanning
4. Integration tests
5. Documentation generation

#### Required Variable Groups

Create a variable group named `terraform-secrets` with:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET` (marked as secret)
- `ARM_SUBSCRIPTION_ID`
- `ARM_TENANT_ID`

## Security Best Practices

### Local Development

1. **Never commit .env files** - They contain sensitive credentials
2. **Use the validation scripts** - They check for placeholder values
3. **Rotate credentials regularly** - Update your service principal keys
4. **Use least privilege** - Only grant necessary permissions

### CI/CD Pipelines

1. **Use native secret management** - GitHub Secrets, Azure Key Vault, etc.
2. **Validate environment** - The pipeline scripts check for .env files
3. **Use service connections** - Where available (Azure DevOps)
4. **Enable audit logging** - Track credential usage

## Troubleshooting

### Common Issues

1. **"Required environment variables are missing"**
   - Check that you've copied `.env.example` to `.env`
   - Ensure you've replaced placeholder values with real credentials
   - Run `make check-env` to validate

2. **"Permission denied" when running scripts**
   - Make scripts executable: `chmod +x scripts/*.sh`
   - Or run the setup script: `./scripts/setup-dev.sh`

3. **"Authentication failed" in Terraform**
   - Verify your service principal credentials
   - Check that the service principal has required permissions
   - Ensure subscription ID is correct

4. **Pipeline failing with authentication errors**
   - Verify secrets are configured in CI/CD platform
   - Check that variable group exists (Azure DevOps)
   - Ensure secret names match exactly

### Debug Commands

```bash
# Check if environment variables are loaded
env | grep ARM_

# Validate Azure credentials
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID

# Test AWS credentials
aws sts get-caller-identity

# Verify GCP credentials
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS
```

## Advanced Configuration

### Custom Backend Configuration

You can override backend configuration in your `.env` file:

```bash
# Use remote backend
TF_CLI_ARGS_init="-backend-config=storage_account_name=mystorageaccount"

# Use local backend for development
TF_CLI_ARGS_init="-backend=false"
```

### Environment-Specific Variables

Add environment-specific variables to your `.env` file:

```bash
# Development environment
TF_VAR_environment="development"
TF_VAR_instance_size="Standard_B1s"

# Production environment would use different values
TF_VAR_environment="production"
TF_VAR_instance_size="Standard_D2s_v3"
```

### Multiple Environments

You can create multiple environment files:

```bash
# Development
.env.dev

# Staging
.env.staging

# Production
.env.prod
```

Then load the appropriate one:

```bash
# Copy the environment you want to use
cp .env.dev .env

# Or source directly
source .env.staging
```

## Contributing

When contributing to this project:

1. Never commit `.env` files
2. Update `.env.example` if you add new variables
3. Test your changes with `make validate`
4. Run security scans before submitting PRs
5. Update documentation as needed

## Support

If you encounter issues:

1. Check this README for common solutions
2. Run the validation scripts to identify problems
3. Check the pipeline logs for specific error messages
4. Ensure all prerequisites are installed and configured
