terraform {
  # This block specifies the required Terraform version.
  required_version = ">= 1.3.0"

  required_providers {
    # This block specifies the required Google Cloud provider and its version constraints.
    google = {
      source  = "hashicorp/google"
      version = ">= 4.63.0, < 6.0.0"
    }
  }
}
