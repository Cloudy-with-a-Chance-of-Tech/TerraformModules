# Global variables for multi-cloud provider configuration

variable "environment" {
  description = "Environment name (development, staging, production)"
  type        = string
  default     = "development"
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "terraform-modules"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "terraform"
}

variable "cost_center" {
  description = "Cost center for resource billing"
  type        = string
  default     = "engineering"
}

# Azure specific variables
variable "azure_location" {
  description = "Azure region for resources"
  type        = string
  default     = "East US"
}

# AWS specific variables (optional)
variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-east-1"
}

# Google Cloud specific variables (optional)
variable "google_project" {
  description = "Google Cloud project ID"
  type        = string
  default     = ""
}

variable "google_region" {
  description = "Google Cloud region for resources"
  type        = string
  default     = "us-central1"
}

# Common tags that will be applied to all resources
variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "development"
    Project     = "terraform-modules"
    CreatedBy   = "Terraform"
    Repository  = "TerraformModules"
  }
}
