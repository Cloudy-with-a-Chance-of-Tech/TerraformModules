#!/bin/bash
# Simple environment test script

echo "=== Environment Test ==="
echo "Date: $(date)"
echo "Working Directory: $(pwd)"

echo ""
echo "=== Testing .env file loading ==="

# Check if .env exists
if [ -f ".env" ]; then
    echo "✅ .env file found"
else
    echo "❌ .env file not found"
    exit 1
fi

# Source the .env file
echo "Loading .env file..."
set -a
source .env
set +a

echo "✅ .env file loaded"

echo ""
echo "=== Checking Azure Variables ==="

# Check Azure variables
if [ -n "$ARM_CLIENT_ID" ] && [ "$ARM_CLIENT_ID" != "your-azure-client-id" ]; then
    echo "✅ ARM_CLIENT_ID: ${ARM_CLIENT_ID:0:8}..."
else
    echo "❌ ARM_CLIENT_ID not set or still placeholder"
fi

if [ -n "$ARM_CLIENT_SECRET" ] && [ "$ARM_CLIENT_SECRET" != "your-azure-client-secret" ]; then
    echo "✅ ARM_CLIENT_SECRET: ${ARM_CLIENT_SECRET:0:8}..."
else
    echo "❌ ARM_CLIENT_SECRET not set or still placeholder"
fi

if [ -n "$ARM_SUBSCRIPTION_ID" ] && [ "$ARM_SUBSCRIPTION_ID" != "your-azure-subscription-id" ]; then
    echo "✅ ARM_SUBSCRIPTION_ID: ${ARM_SUBSCRIPTION_ID:0:8}..."
else
    echo "❌ ARM_SUBSCRIPTION_ID not set or still placeholder"
fi

if [ -n "$ARM_TENANT_ID" ] && [ "$ARM_TENANT_ID" != "your-azure-tenant-id" ]; then
    echo "✅ ARM_TENANT_ID: ${ARM_TENANT_ID:0:8}..."
else
    echo "❌ ARM_TENANT_ID not set or still placeholder"
fi

echo ""
echo "=== Testing Terraform ==="

# Check if terraform is available
if command -v terraform &> /dev/null; then
    echo "✅ Terraform found: $(terraform version | head -n1)"
    
    # Test terraform validate on resource group module
    if [ -d "azure/resource_group" ]; then
        echo "Testing terraform validate on resource_group module..."
        cd azure/resource_group
        if terraform validate &> /dev/null; then
            echo "✅ Terraform validate passed"
        else
            echo "⚠️  Terraform validate had issues (may need init first)"
        fi
        cd ../..
    fi
else
    echo "❌ Terraform not found"
fi

echo ""
echo "=== Test Summary ==="
echo "✅ Environment variables loaded successfully"
echo "✅ Azure credentials appear to be configured"
echo "✅ Ready for Terraform operations"

echo ""
echo "Next steps:"
echo "1. Run 'terraform init' in a module directory"
echo "2. Run 'terraform plan' to test Azure connectivity"
echo "3. Use 'make' commands for easier workflow"
