#!/bin/bash
# Pipeline validation script - ensures .env files are not used in CI/CD

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[PIPELINE]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[PIPELINE]${NC} $1"
}

print_error() {
    echo -e "${RED}[PIPELINE]${NC} $1"
}

print_status "Running pipeline environment validation..."

# Check if we're in a CI/CD environment
CI_DETECTED=false

if [[ "${CI}" == "true" ]]; then
    CI_DETECTED=true
    print_status "Detected generic CI environment"
fi

if [[ "${GITHUB_ACTIONS}" == "true" ]]; then
    CI_DETECTED=true
    print_status "Detected GitHub Actions environment"
fi

if [[ "${AZURE_PIPELINES}" == "true" || "${TF_BUILD}" == "true" ]]; then
    CI_DETECTED=true
    print_status "Detected Azure DevOps Pipelines environment"
fi

if [[ "${JENKINS_URL}" != "" ]]; then
    CI_DETECTED=true
    print_status "Detected Jenkins environment"
fi

if [[ "${GITLAB_CI}" == "true" ]]; then
    CI_DETECTED=true
    print_status "Detected GitLab CI environment"
fi

if [[ "$CI_DETECTED" == "false" ]]; then
    print_warning "No CI/CD environment detected - this script should only run in pipelines"
    exit 1
fi

# Verify that .env file is not present (should be gitignored)
if [[ -f ".env" ]]; then
    print_error ".env file found in CI/CD environment!"
    print_error "This file should be gitignored and not committed to repository"
    exit 1
fi

# Check for required environment variables based on cloud provider
check_azure_vars() {
    local missing_vars=()
    
    if [[ -z "$ARM_CLIENT_ID" ]]; then missing_vars+=("ARM_CLIENT_ID"); fi
    if [[ -z "$ARM_CLIENT_SECRET" ]]; then missing_vars+=("ARM_CLIENT_SECRET"); fi
    if [[ -z "$ARM_SUBSCRIPTION_ID" ]]; then missing_vars+=("ARM_SUBSCRIPTION_ID"); fi
    if [[ -z "$ARM_TENANT_ID" ]]; then missing_vars+=("ARM_TENANT_ID"); fi
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        print_error "Missing required Azure environment variables:"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        return 1
    fi
    
    print_status "Azure environment variables are properly configured"
    return 0
}

check_aws_vars() {
    local missing_vars=()
    
    if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then missing_vars+=("AWS_ACCESS_KEY_ID"); fi
    if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then missing_vars+=("AWS_SECRET_ACCESS_KEY"); fi
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        print_warning "AWS environment variables not configured (optional):"
        for var in "${missing_vars[@]}"; do
            echo "  - $var"
        done
        return 1
    fi
    
    print_status "AWS environment variables are properly configured"
    return 0
}

check_gcp_vars() {
    if [[ -z "$GOOGLE_APPLICATION_CREDENTIALS" && -z "$GOOGLE_CREDENTIALS" ]]; then
        print_warning "GCP environment variables not configured (optional)"
        return 1
    fi
    
    print_status "GCP environment variables are properly configured"
    return 0
}

# Check cloud provider configurations
AZURE_OK=false
AWS_OK=false
GCP_OK=false

if check_azure_vars; then
    AZURE_OK=true
fi

if check_aws_vars; then
    AWS_OK=true
fi

if check_gcp_vars; then
    GCP_OK=true
fi

# At least one cloud provider should be configured
if [[ "$AZURE_OK" == "false" && "$AWS_OK" == "false" && "$GCP_OK" == "false" ]]; then
    print_error "No cloud provider credentials are properly configured"
    print_error "At least one cloud provider (Azure, AWS, or GCP) must be configured"
    exit 1
fi

# Set Terraform environment variables for CI/CD
export TF_IN_AUTOMATION="true"
export TF_INPUT="false"
export TF_CLI_ARGS_init="-input=false"
export TF_CLI_ARGS_plan="-input=false"
export TF_CLI_ARGS_apply="-input=false -auto-approve"

print_status "Pipeline environment validation completed successfully"
print_status "Terraform automation mode enabled"

# Output summary
echo ""
print_status "Cloud Provider Status:"
echo "  Azure: $([ "$AZURE_OK" == "true" ] && echo "✓ Configured" || echo "✗ Not configured")"
echo "  AWS:   $([ "$AWS_OK" == "true" ] && echo "✓ Configured" || echo "✗ Not configured")"
echo "  GCP:   $([ "$GCP_OK" == "true" ] && echo "✓ Configured" || echo "✗ Not configured")"
echo ""
