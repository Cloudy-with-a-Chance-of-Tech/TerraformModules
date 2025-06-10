# TerraformModules

A collection of reusable Terraform modules for multi-cloud infrastructure deployment with a focus on Azure, AWS, and Google Cloud Platform.

## 🚀 Quick Start

### 1. Environment Setup
```bash
# Clone the repository
git clone <repository-url>
cd TerraformModules

# Set up your environment
cp .env.example .env
# Edit .env with your actual cloud provider credentials

# Validate setup
chmod +x validate-setup.sh
./validate-setup.sh

# Test environment
make check-env
make load-env
```

### 2. Initialize Terraform
```bash
make init
```

### 3. Plan and Apply
```bash
make plan
make apply
```

## 📁 Repository Structure

```
├── azure/                     # Azure modules
│   ├── resource_group/        # Resource group module
│   ├── virtual_networks/      # Virtual network module
│   └── win_compute/          # Windows compute module
├── scripts/                   # Environment and utility scripts
│   ├── load-env.sh           # Load local environment
│   ├── pipeline-env.sh       # Pipeline environment validation
│   └── setup-dev.sh          # Development setup
├── tests/                     # Integration tests
├── .env.example              # Environment template
├── Makefile                  # Development commands
└── ENVIRONMENT_SETUP.md      # Detailed setup guide
```

## 🔧 Available Commands

Run `make help` to see all available commands:

- **Environment**: `setup`, `check-env`, `load-env`
- **Terraform**: `init`, `plan`, `apply`, `destroy`, `validate`, `fmt`
- **Module Testing**: `test-rg`, `test-vnet`, `test-vm`
- **Utilities**: `clean`

## 🌍 Supported Cloud Providers

### Azure (Primary)
- ✅ Resource Groups
- ✅ Virtual Networks
- 🚧 Windows Compute (in development)
- 🔄 Storage Accounts (planned)
- 🔄 Key Vault (planned)

### AWS (Optional)
- 🔄 VPC (planned)
- 🔄 EC2 (planned)

### Google Cloud (Optional)
- 🔄 VPC (planned)
- 🔄 Compute Engine (planned)

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.6.0
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) (for Azure)
- [AWS CLI](https://aws.amazon.com/cli/) (for AWS, optional)
- [Google Cloud CLI](https://cloud.google.com/sdk/docs/install) (for GCP, optional)
- Make (for using Makefile commands)

## 🔐 Security & Best Practices

- **Local Development**: Uses `.env` file for credentials (never committed)
- **CI/CD Pipelines**: Uses platform-native secret management
- **Validation**: Scripts validate environment and reject placeholder values
- **Minimal Permissions**: Service principals with least-privilege access

## 🔄 CI/CD Integration

### GitHub Actions
- Automatic validation and testing
- Security scanning with Checkov
- Documentation generation
- Multi-module testing strategy

### Azure DevOps
- Pipeline validation
- Integration tests
- Security compliance checks

## 📚 Documentation

- **[Environment Setup Guide](ENVIRONMENT_SETUP.md)** - Complete setup instructions
- **[Environment Completion Summary](ENV_COMPLETION_SUMMARY.md)** - Setup verification
- **[Testing Guide](TESTING_GUIDE.md)** - Module testing instructions
- **[Project Status](PROJECT_STATUS.md)** - Current development status

## 🆘 Troubleshooting

### Quick Fixes
```bash
# Validate your setup
./validate-setup.sh

# Fix script permissions
chmod +x scripts/*.sh

# Reset environment
make clean
make setup
```

### Common Issues
1. **Environment validation fails**: Check `.env` file has real credentials
2. **Permission denied**: Make scripts executable with `chmod +x scripts/*.sh`
3. **Authentication errors**: Verify service principal permissions

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Set up your environment with `make setup`
4. Make your changes
5. Test with `make validate` and `make test-*`
6. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔗 Resources

- [Terraform Documentation](https://www.terraform.io/docs)
- [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Google Cloud Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
