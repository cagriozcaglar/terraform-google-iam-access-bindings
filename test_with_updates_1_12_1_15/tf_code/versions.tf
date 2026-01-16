terraform {
  # This module is designed to work with Terraform 1.3 and newer, which supports features like 'optional' attributes in complex types.
  required_version = ">= 1.3"

  required_providers {
    # Google Provider is required for managing Google Cloud IAM resources.
    google = {
      source  = "hashicorp/google"
      version = "~> 5.14"
    }
  }
}
