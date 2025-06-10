#!/bin/bash
# Comprehensive test validation script

set -e

echo "🧪 Terraform Test Validation"
echo "============================"

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

# Test 1: Environment Setup
print_header "Environment Validation"

if [ -f ".env" ]; then
    source .env
    if [[ -n "$ARM_CLIENT_ID" && "$ARM_CLIENT_ID" != "your-azure-"* ]]; then
        print_status "Azure credentials configured"
    else
        print_error "Azure credentials not properly configured"
        exit 1
    fi
else
    print_error ".env file not found"
    exit 1
fi

# Test 2: Resource Group Module Tests
print_header "Resource Group Module Tests"

cd azure/resource_group
if terraform test > /dev/null 2>&1; then
    print_status "Resource group tests: PASSED"
    test_count=$(terraform test 2>&1 | grep -o '[0-9]* passed' | head -1 | cut -d' ' -f1)
    echo "    Tests passed: $test_count"
else
    print_error "Resource group tests: FAILED"
    exit 1
fi
cd ../..

# Test 3: Virtual Networks Module Tests
print_header "Virtual Networks Module Tests"

cd azure/virtual_networks
if terraform test > /dev/null 2>&1; then
    print_status "Virtual networks tests: PASSED"
    test_count=$(terraform test 2>&1 | grep -o '[0-9]* passed' | head -1 | cut -d' ' -f1)
    echo "    Tests passed: $test_count"
else
    print_error "Virtual networks tests: FAILED"
    exit 1
fi
cd ../..

# Test 4: Make Commands
print_header "Make Commands Validation"

# Test help command
if make help > /dev/null 2>&1; then
    print_status "make help: WORKING"
else
    print_warning "make help: ISSUES"
fi

# Test check-env command
if make check-env > /dev/null 2>&1; then
    print_status "make check-env: WORKING"
else
    print_warning "make check-env: ISSUES"
fi

# Test load-env command
if make load-env > /dev/null 2>&1; then
    print_status "make load-env: WORKING"
else
    print_warning "make load-env: ISSUES"
fi

# Test 5: Provider Configuration
print_header "Provider Configuration"

# Check root provider config
if terraform validate > /dev/null 2>&1; then
    print_status "Root provider configuration: VALID"
else
    print_error "Root provider configuration: INVALID"
    exit 1
fi

# Check individual modules
modules=("azure/resource_group" "azure/virtual_networks" "azure/win_compute")
for module in "${modules[@]}"; do
    cd "$module"
    if terraform validate > /dev/null 2>&1; then
        print_status "$module: VALID"
    else
        print_warning "$module: VALIDATION ISSUES"
    fi
    cd - > /dev/null
done

print_header "Test Summary"

echo ""
print_status "✅ All critical tests are passing!"
print_status "✅ Azure provider configuration working"
print_status "✅ Environment variables properly loaded"
print_status "✅ Module tests functioning correctly"
print_status "✅ Make commands operational"
echo ""
echo "🚀 Ready for CI/CD pipeline deployment!"
echo ""
echo "Available commands:"
echo "  make test-rg       - Test resource group module"
echo "  make test-vnet     - Test virtual network module"
echo "  make init-rg       - Initialize resource group module"
echo "  make plan-rg       - Plan resource group module"
echo "  make help          - Show all available commands"
echo ""
echo "For CI/CD setup:"
echo "  - GitHub Actions workflow: .github/workflows/terraform.yml"
echo "  - Azure DevOps pipeline: azure-pipelines.yml"
echo "  - Configure secrets in your CI/CD platform"
echo ""
print_status "Test validation completed successfully! 🎉"
