# Multi-Cloud Provider Configuration
# This file contains the main provider configurations for all cloud platforms

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

# Azure Provider Configuration
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }

  # For testing and development - allows faster testing
  skip_provider_registration = true
}

# AWS Provider Configuration (Optional)
provider "aws" {
  # Configuration will be taken from environment variables
  # AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION

  default_tags {
    tags = {
      Environment = var.environment
      Project     = var.project_name
      Owner       = var.owner
      CreatedBy   = "Terraform"
      Repository  = "TerraformModules"
    }
  }
}

# Google Cloud Provider Configuration (Optional)
provider "google" {
  # Configuration will be taken from environment variables
  # GOOGLE_APPLICATION_CREDENTIALS, GOOGLE_PROJECT, GOOGLE_REGION

  project = var.google_project
  region  = var.google_region
}
