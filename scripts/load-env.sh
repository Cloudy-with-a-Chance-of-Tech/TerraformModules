#!/bin/bash
# Load environment variables for local development

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a CI/CD pipeline
if [[ "${CI}" == "true" || "${GITHUB_ACTIONS}" == "true" || "${AZURE_PIPELINES}" == "true" || "${TF_BUILD}" == "true" ]]; then
    print_status "Running in CI/CD pipeline - skipping .env file loading"
    exit 0
fi

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Load .env file if it exists
ENV_FILE="$PROJECT_ROOT/.env"
if [[ -f "$ENV_FILE" ]]; then
    print_status "Loading environment variables from .env file..."
    
    # Export variables from .env file, ignoring comments and empty lines
    set -a
    source "$ENV_FILE"
    set +a
    
    print_status "Environment variables loaded successfully"
else
    print_error ".env file not found at $ENV_FILE"
    print_warning "Please create one based on .env.example"
    exit 1
fi

# Validate required Azure variables
azure_required_vars=("ARM_CLIENT_ID" "ARM_CLIENT_SECRET" "ARM_SUBSCRIPTION_ID" "ARM_TENANT_ID")
missing_vars=()

for var in "${azure_required_vars[@]}"; do
    if [[ -z "${!var}" || "${!var}" == "your-azure-"* ]]; then
        missing_vars+=("$var")
    fi
done

if [[ ${#missing_vars[@]} -gt 0 ]]; then
    print_error "Required Azure environment variables are missing or contain placeholder values:"
    for var in "${missing_vars[@]}"; do
        echo "  - $var"
    done
    print_warning "Please update your .env file with actual values"
    exit 1
fi

# Validate AWS variables (optional, warn if not set properly)
if [[ -n "${AWS_ACCESS_KEY_ID}" && "${AWS_ACCESS_KEY_ID}" != "your-aws-"* ]]; then
    if [[ -z "${AWS_SECRET_ACCESS_KEY}" || "${AWS_SECRET_ACCESS_KEY}" == "your-aws-"* ]]; then
        print_warning "AWS_ACCESS_KEY_ID is set but AWS_SECRET_ACCESS_KEY is missing or contains placeholder"
    else
        print_status "AWS credentials detected and appear valid"
    fi
fi

# Validate GCP variables (optional, warn if not set properly)
if [[ -n "${GOOGLE_APPLICATION_CREDENTIALS}" && "${GOOGLE_APPLICATION_CREDENTIALS}" != "/path/to/"* ]]; then
    if [[ ! -f "${GOOGLE_APPLICATION_CREDENTIALS}" ]]; then
        print_warning "GOOGLE_APPLICATION_CREDENTIALS points to non-existent file: ${GOOGLE_APPLICATION_CREDENTIALS}"
    else
        print_status "GCP service account key file found"
    fi
fi

# Set additional environment variables for Terraform
export TF_IN_AUTOMATION="false"
export TF_INPUT="false"

print_status "All required environment variables are set and validated"
print_status "You can now run Terraform commands"
