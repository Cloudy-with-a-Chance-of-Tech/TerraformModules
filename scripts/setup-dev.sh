#!/bin/bash
# Development setup script for Terraform modules

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_header() {
    echo -e "${BLUE}============================================${NC}"
    echo -e "${BLUE} $1${NC}"
    echo -e "${BLUE}============================================${NC}"
}

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

print_header "Terraform Multi-Cloud Development Setup"

# Check if Terraform is installed
if ! command -v terraform &> /dev/null; then
    print_error "Terraform is not installed. Please install Terraform first."
    print_status "Visit: https://www.terraform.io/downloads.html"
    exit 1
else
    print_status "Terraform is installed: $(terraform version | head -n1)"
fi

# Check if Azure CLI is installed (optional)
if command -v az &> /dev/null; then
    print_status "Azure CLI is installed: $(az version --query '"azure-cli"' -o tsv 2>/dev/null || echo 'version check failed')"
else
    print_warning "Azure CLI is not installed. Some features may not work."
    print_status "Install from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
fi

# Check if AWS CLI is installed (optional)
if command -v aws &> /dev/null; then
    print_status "AWS CLI is installed: $(aws --version 2>&1 | cut -d/ -f2 | cut -d' ' -f1)"
else
    print_warning "AWS CLI is not installed. AWS features will not work."
fi

# Check if gcloud is installed (optional)
if command -v gcloud &> /dev/null; then
    print_status "Google Cloud CLI is installed: $(gcloud version --format='value(Google Cloud SDK)' 2>/dev/null || echo 'version check failed')"
else
    print_warning "Google Cloud CLI is not installed. GCP features will not work."
fi

# Create .env file if it doesn't exist
ENV_FILE="$PROJECT_ROOT/.env"
ENV_EXAMPLE="$PROJECT_ROOT/.env.example"

if [[ ! -f "$ENV_FILE" ]]; then
    if [[ -f "$ENV_EXAMPLE" ]]; then
        print_status "Creating .env file from .env.example..."
        cp "$ENV_EXAMPLE" "$ENV_FILE"
        print_warning "Please edit .env file with your actual credentials"
        print_status "File location: $ENV_FILE"
    else
        print_error ".env.example file not found!"
        exit 1
    fi
else
    print_status ".env file already exists"
fi

# Check if scripts directory exists and has correct permissions
SCRIPTS_DIR="$PROJECT_ROOT/scripts"
if [[ -d "$SCRIPTS_DIR" ]]; then
    # Make all scripts executable
    find "$SCRIPTS_DIR" -name "*.sh" -exec chmod +x {} \;
    print_status "Made all scripts in $SCRIPTS_DIR executable"
else
    print_error "Scripts directory not found: $SCRIPTS_DIR"
    exit 1
fi

# Create terraform.rc file for faster provider downloads (optional)
TERRAFORM_RC="$HOME/.terraformrc"
if [[ ! -f "$TERRAFORM_RC" ]]; then
    print_status "Creating terraform.rc file for faster provider downloads..."
    cat > "$TERRAFORM_RC" << EOF
plugin_cache_dir = "\$HOME/.terraform.d/plugin-cache"
disable_checkpoint = true
EOF
    mkdir -p "$HOME/.terraform.d/plugin-cache"
    print_status "Created terraform.rc with plugin caching enabled"
else
    print_status "terraform.rc file already exists"
fi

# Validate .env file
print_header "Validating Environment Configuration"

if source "$ENV_FILE" 2>/dev/null; then
    # Check Azure credentials
    if [[ -n "$ARM_CLIENT_ID" && "$ARM_CLIENT_ID" != "your-azure-"* ]]; then
        print_status "Azure credentials appear to be configured"
    else
        print_warning "Azure credentials need to be configured in .env file"
    fi
    
    # Check AWS credentials
    if [[ -n "$AWS_ACCESS_KEY_ID" && "$AWS_ACCESS_KEY_ID" != "your-aws-"* ]]; then
        print_status "AWS credentials appear to be configured"
    else
        print_warning "AWS credentials are not configured (optional)"
    fi
    
    # Check GCP credentials
    if [[ -n "$GOOGLE_APPLICATION_CREDENTIALS" && "$GOOGLE_APPLICATION_CREDENTIALS" != "/path/to/"* ]]; then
        if [[ -f "$GOOGLE_APPLICATION_CREDENTIALS" ]]; then
            print_status "GCP service account key file found"
        else
            print_warning "GCP service account key file not found at: $GOOGLE_APPLICATION_CREDENTIALS"
        fi
    else
        print_warning "GCP credentials are not configured (optional)"
    fi
else
    print_error "Failed to source .env file. Please check the syntax."
    exit 1
fi

print_header "Setup Complete"

print_status "Development environment is ready!"
print_status ""
print_status "Next steps:"
print_status "1. Edit .env file with your actual credentials"
print_status "2. Run 'make help' to see available commands"
print_status "3. Run 'make check-env' to validate your configuration"
print_status "4. Run 'make init' to initialize Terraform"
print_status ""
print_status "Useful commands:"
print_status "  make setup      - Copy .env.example to .env"
print_status "  make load-env   - Load and validate environment variables"
print_status "  make init       - Initialize Terraform"
print_status "  make plan       - Run Terraform plan"
print_status "  make apply      - Apply Terraform changes"
print_status ""
print_warning "Remember: Never commit .env file to version control!"
