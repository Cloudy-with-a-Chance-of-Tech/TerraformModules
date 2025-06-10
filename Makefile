# Terraform Multi-Cloud Makefile
# This Makefile provides convenient commands for managing Terraform with environment variables

.DEFAULT_GOAL := help
.PHONY: help init plan apply destroy clean load-env validate fmt check-env setup

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[1;33m
RED := \033[0;31m
NC := \033[0m # No Color

# Project settings
PROJECT_ROOT := $(shell pwd)
SCRIPTS_DIR := $(PROJECT_ROOT)/scripts
ENV_FILE := $(PROJECT_ROOT)/.env
ENV_EXAMPLE := $(PROJECT_ROOT)/.env.example

## help: Show this help message
help:
	@echo "$(GREEN)Terraform Multi-Cloud Management$(NC)"
	@echo ""
	@echo "$(YELLOW)Setup Commands:$(NC)"
	@echo "  setup      - Initial setup (copy .env.example to .env)"
	@echo "  check-env  - Validate environment variables"
	@echo "  load-env   - Load and validate environment variables"
	@echo ""
	@echo "$(YELLOW)Terraform Commands:$(NC)"
	@echo "  validate   - Validate Terraform configuration"
	@echo "  fmt        - Format Terraform files"
	@echo "  init       - Initialize Terraform with loaded environment"
	@echo "  plan       - Run Terraform plan with loaded environment"
	@echo "  apply      - Run Terraform apply with loaded environment"
	@echo "  destroy    - Run Terraform destroy with loaded environment"
	@echo ""
	@echo "$(YELLOW)Utility Commands:$(NC)"
	@echo "  clean      - Clean Terraform files and state"
	@echo ""
	@echo "$(YELLOW)Module-specific Commands:$(NC)"
	@echo "  test-rg    - Test resource group module"
	@echo "  test-vnet  - Test virtual network module"
	@echo "  test-vm    - Test Windows compute module"

## setup: Copy .env.example to .env for initial setup
setup:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo "$(GREEN)Creating .env file from .env.example...$(NC)"; \
		cp "$(ENV_EXAMPLE)" "$(ENV_FILE)"; \
		echo "$(YELLOW)Please edit .env file with your actual credentials$(NC)"; \
	else \
		echo "$(YELLOW).env file already exists$(NC)"; \
	fi

## check-env: Check if .env file exists and has required variables
check-env:
	@if [ ! -f "$(ENV_FILE)" ]; then \
		echo "$(RED)Error: .env file not found$(NC)"; \
		echo "$(YELLOW)Run 'make setup' to create it from the example$(NC)"; \
		exit 1; \
	fi
	@echo "$(GREEN).env file exists$(NC)"

## load-env: Load and validate environment variables
load-env: check-env
	@echo "$(GREEN)Loading environment variables...$(NC)"
	@bash $(SCRIPTS_DIR)/load-env.sh

## validate: Validate Terraform configuration
validate: load-env
	@echo "$(GREEN)Validating Terraform configuration...$(NC)"
	@bash -c "source $(ENV_FILE) && terraform validate"

## fmt: Format Terraform files
fmt:
	@echo "$(GREEN)Formatting Terraform files...$(NC)"
	@terraform fmt -recursive

## init: Initialize Terraform with environment variables
init: load-env
	@echo "$(GREEN)Initializing Terraform...$(NC)"
	@bash -c "source $(ENV_FILE) && terraform init"

## plan: Run Terraform plan with environment variables
plan: load-env
	@echo "$(GREEN)Running Terraform plan...$(NC)"
	@bash -c "source $(ENV_FILE) && terraform plan"

## apply: Run Terraform apply with environment variables
apply: load-env
	@echo "$(GREEN)Running Terraform apply...$(NC)"
	@bash -c "source $(ENV_FILE) && terraform apply"

## destroy: Run Terraform destroy with environment variables
destroy: load-env
	@echo "$(YELLOW)Running Terraform destroy...$(NC)"
	@bash -c "source $(ENV_FILE) && terraform destroy"

## clean: Clean Terraform files and state
clean:
	@echo "$(GREEN)Cleaning Terraform files...$(NC)"
	@rm -rf .terraform/
	@rm -f .terraform.lock.hcl
	@rm -f terraform.tfstate*
	@rm -f *.tfplan
	@rm -f terraform.log
	@echo "$(GREEN)Terraform files cleaned$(NC)"

## test-rg: Test resource group module
test-rg: load-env
	@echo "$(GREEN)Testing resource group module...$(NC)"
	@cd azure/resource_group && bash -c "source ../../.env && terraform test"

## test-vnet: Test virtual network module
test-vnet: load-env
	@echo "$(GREEN)Testing virtual network module...$(NC)"
	@cd azure/virtual_networks && bash -c "source ../../.env && terraform test"

## test-vm: Test Windows compute module
test-vm: load-env
	@echo "$(GREEN)Testing Windows compute module...$(NC)"
	@cd azure/win_compute && source $(ENV_FILE) && terraform test

# Module-specific init, plan, apply commands
## init-rg: Initialize resource group module
init-rg: load-env
	@echo "$(GREEN)Initializing resource group module...$(NC)"
	@cd azure/resource_group && bash -c "source ../../.env && terraform init"

## plan-rg: Plan resource group module
plan-rg: load-env
	@echo "$(GREEN)Planning resource group module...$(NC)"
	@cd azure/resource_group && bash -c "source ../../.env && terraform plan"

## apply-rg: Apply resource group module
apply-rg: load-env
	@echo "$(GREEN)Applying resource group module...$(NC)"
	@cd azure/resource_group && bash -c "source ../../.env && terraform apply"

## init-vnet: Initialize virtual network module
init-vnet: load-env
	@echo "$(GREEN)Initializing virtual network module...$(NC)"
	@cd azure/virtual_networks && bash -c "source ../../.env && terraform init"

## plan-vnet: Plan virtual network module
plan-vnet: load-env
	@echo "$(GREEN)Planning virtual network module...$(NC)"
	@cd azure/virtual_networks && bash -c "source ../../.env && terraform plan"

## apply-vnet: Apply virtual network module
apply-vnet: load-env
	@echo "$(GREEN)Applying virtual network module...$(NC)"
	@cd azure/virtual_networks && bash -c "source ../../.env && terraform apply"

## init-vm: Initialize Windows compute module
init-vm: load-env
	@echo "$(GREEN)Initializing Windows compute module...$(NC)"
	@cd azure/win_compute && bash -c "source ../../.env && terraform init"

## plan-vm: Plan Windows compute module
plan-vm: load-env
	@echo "$(GREEN)Planning Windows compute module...$(NC)"
	@cd azure/win_compute && bash -c "source ../../.env && terraform plan"

## apply-vm: Apply Windows compute module
apply-vm: load-env
	@echo "$(GREEN)Applying Windows compute module...$(NC)"
	@cd azure/win_compute && bash -c "source ../../.env && terraform apply"
