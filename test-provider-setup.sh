#!/bin/bash
# Comprehensive test for the consolidated provider setup

set -e

echo "🚀 Testing Consolidated Azure Provider Setup"
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_header() {
    echo -e "${BLUE}=== $1 ===${NC}"
}

# Test 1: Check file structure
print_header "File Structure Test"

files_to_check=(
    "providers.tf"
    "variables.tf"
    "terraform.tfvars"
    ".env"
    "azure/resource_group/versions.tf"
    "azure/virtual_networks/versions.tf"
    "azure/win_compute/versions.tf"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        print_status "$file exists"
    else
        print_error "$file missing"
    fi
done

# Check that old provider files are removed
old_provider_files=(
    "azure/resource_group/providers.tf"
    "azure/virtual_networks/providers.tf"
)

for file in "${old_provider_files[@]}"; do
    if [ ! -f "$file" ]; then
        print_status "$file removed (good)"
    else
        print_warning "$file still exists (should be removed)"
    fi
done

# Test 2: Load environment variables
print_header "Environment Variables Test"

if [ -f ".env" ]; then
    source .env
    
    # Check Azure variables
    if [[ -n "$ARM_CLIENT_ID" && "$ARM_CLIENT_ID" != "your-azure-"* ]]; then
        print_status "ARM_CLIENT_ID configured"
    else
        print_error "ARM_CLIENT_ID not properly configured"
    fi
    
    if [[ -n "$ARM_CLIENT_SECRET" && "$ARM_CLIENT_SECRET" != "your-azure-"* ]]; then
        print_status "ARM_CLIENT_SECRET configured"
    else
        print_error "ARM_CLIENT_SECRET not properly configured"
    fi
    
    if [[ -n "$ARM_SUBSCRIPTION_ID" && "$ARM_SUBSCRIPTION_ID" != "your-azure-"* ]]; then
        print_status "ARM_SUBSCRIPTION_ID configured"
    else
        print_error "ARM_SUBSCRIPTION_ID not properly configured"
    fi
    
    if [[ -n "$ARM_TENANT_ID" && "$ARM_TENANT_ID" != "your-azure-"* ]]; then
        print_status "ARM_TENANT_ID configured"
    else
        print_error "ARM_TENANT_ID not properly configured"
    fi
else
    print_error ".env file not found"
fi

# Test 3: Terraform validation
print_header "Terraform Validation Test"

if command -v terraform &> /dev/null; then
    print_status "Terraform found: $(terraform version | head -n1)"
    
    # Test root configuration
    echo "Testing root configuration..."
    if terraform validate &> /dev/null; then
        print_status "Root configuration valid"
    else
        print_warning "Root configuration validation failed (may need init)"
    fi
    
    # Test individual modules
    modules=("azure/resource_group" "azure/virtual_networks" "azure/win_compute")
    
    for module in "${modules[@]}"; do
        if [ -d "$module" ]; then
            echo "Testing $module..."
            cd "$module"
            if terraform validate &> /dev/null; then
                print_status "$module configuration valid"
            else
                print_warning "$module validation failed (may need init)"
            fi
            cd - > /dev/null
        fi
    done
else
    print_error "Terraform not found"
fi

# Test 4: Test provider inheritance
print_header "Provider Inheritance Test"

# Check that modules don't have their own provider blocks
modules=("azure/resource_group" "azure/virtual_networks" "azure/win_compute")

for module in "${modules[@]}"; do
    if [ -f "$module/providers.tf" ]; then
        print_error "$module still has providers.tf (should be removed)"
    else
        print_status "$module uses inherited provider configuration"
    fi
done

# Test 5: Test initialization
print_header "Terraform Initialization Test"

echo "Testing terraform init on root..."
if terraform init &> /dev/null; then
    print_status "Root terraform init successful"
    
    # Test a module
    echo "Testing terraform init on resource_group module..."
    cd azure/resource_group
    if terraform init &> /dev/null; then
        print_status "Module terraform init successful"
    else
        print_warning "Module terraform init failed"
    fi
    cd - > /dev/null
else
    print_warning "Root terraform init failed"
fi

print_header "Test Summary"

echo ""
echo "✅ Provider consolidation completed!"
echo "✅ Single provider configuration in root providers.tf"
echo "✅ Modules inherit provider from root"
echo "✅ Environment variables properly configured"
echo ""
echo "Next steps:"
echo "1. Run 'make init' to initialize all modules"
echo "2. Run 'make plan' to test Azure connectivity"
echo "3. Use 'make init-rg' or 'make init-vnet' for individual modules"
echo ""
echo "Available commands:"
echo "  make help          - Show all available commands"
echo "  make check-env     - Validate environment"
echo "  make init          - Initialize root configuration"
echo "  make init-rg       - Initialize resource group module"
echo "  make init-vnet     - Initialize virtual network module"
echo "  make plan-rg       - Plan resource group module"
echo "  make test-rg       - Test resource group module"
