#!/bin/bash
# Quick validation script for environment setup

echo "🔍 Environment Setup Validation"
echo "================================"

# Check if we're in the right directory
if [ ! -f "Makefile" ] || [ ! -d "scripts" ]; then
    echo "❌ Please run this script from the TerraformModules root directory"
    exit 1
fi

echo "✅ In correct directory"

# Check essential files
echo ""
echo "📁 Checking essential files..."

files_to_check=(
    ".env"
    ".env.example"
    "Makefile"
    "scripts/load-env.sh"
    "scripts/pipeline-env.sh"
    "scripts/setup-dev.sh"
    "ENVIRONMENT_SETUP.md"
)

for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done

# Check script permissions
echo ""
echo "🔧 Checking script permissions..."
for script in scripts/*.sh; do
    if [ -x "$script" ]; then
        echo "✅ $script is executable"
    else
        echo "⚠️  $script needs executable permission (run: chmod +x $script)"
    fi
done

# Check .env file content
echo ""
echo "🔐 Checking .env file..."
if [ -f ".env" ]; then
    if grep -q "your-azure-" .env; then
        echo "⚠️  .env file contains placeholder values"
        echo "   Edit .env file with your actual credentials to proceed"
    else
        echo "✅ .env file appears to have real values"
    fi
else
    echo "❌ .env file missing - run 'cp .env.example .env' and edit with your credentials"
fi

# Check gitignore
echo ""
echo "🛡️  Checking .gitignore..."
if grep -q "\.env$" .gitignore 2>/dev/null; then
    echo "✅ .env files are properly gitignored"
else
    echo "⚠️  .env might not be properly gitignored"
fi

echo ""
echo "📋 Summary"
echo "=========="
echo "1. If you see ⚠️  for .env placeholders: Edit .env with your actual Azure credentials"
echo "2. If you see ⚠️  for script permissions: Run 'chmod +x scripts/*.sh'"
echo "3. Then test with: 'make check-env' and 'make load-env'"
echo "4. Initialize Terraform with: 'make init'"
echo ""
echo "📖 For detailed instructions, see: ENVIRONMENT_SETUP.md"
