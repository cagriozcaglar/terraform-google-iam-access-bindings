terraform {
  # This module is compatible with Terraform 1.3.0 and higher.
  required_version = ">= 1.3.0"

  required_providers {
    # The Google Cloud provider is required for managing IAM bindings.
    google = {
      source  = "hashicorp/google"
      version = ">= 4.54.0"
    }
  }
}
