#!/bin/bash
# Simple test script to verify environment setup

echo "=== Environment Setup Test ==="
echo "Current directory: $(pwd)"
echo "Date: $(date)"

echo ""
echo "=== Checking File Structure ==="
echo "✓ Checking .env file..."
if [ -f ".env" ]; then
    echo "  ✓ .env file exists"
else
    echo "  ✗ .env file missing"
fi

echo "✓ Checking .env.example file..."
if [ -f ".env.example" ]; then
    echo "  ✓ .env.example file exists"
else
    echo "  ✗ .env.example file missing"
fi

echo "✓ Checking scripts directory..."
if [ -d "scripts" ]; then
    echo "  ✓ scripts directory exists"
    echo "  Scripts found:"
    ls -la scripts/ | grep "\.sh$" | awk '{print "    - " $9}'
else
    echo "  ✗ scripts directory missing"
fi

echo "✓ Checking Makefile..."
if [ -f "Makefile" ]; then
    echo "  ✓ Makefile exists"
else
    echo "  ✗ Makefile missing"
fi

echo ""
echo "=== Checking Script Permissions ==="
for script in scripts/*.sh; do
    if [ -x "$script" ]; then
        echo "  ✓ $script is executable"
    else
        echo "  ✗ $script is not executable"
        echo "    Run: chmod +x $script"
    fi
done

echo ""
echo "=== Testing Environment Variables ==="
echo "Checking for placeholder values in .env..."

# Check if .env has placeholder values
if grep -q "your-azure-" .env 2>/dev/null; then
    echo "  ⚠ Found placeholder values in .env file"
    echo "    This is expected for initial setup"
    echo "    Replace placeholders with actual credentials to use"
else
    echo "  ✓ No placeholder values found"
fi

echo ""
echo "=== Testing Make Commands ==="
echo "Available make targets:"
if [ -f "Makefile" ]; then
    # Extract help information from Makefile
    grep "^##" Makefile | sed 's/## /  /' 2>/dev/null || echo "  (No help available)"
else
    echo "  (Makefile not found)"
fi

echo ""
echo "=== Test Complete ==="
echo "To get started:"
echo "1. Edit .env file with your actual credentials"
echo "2. Run: make check-env"
echo "3. Run: make load-env"
echo "4. Run: make init"
