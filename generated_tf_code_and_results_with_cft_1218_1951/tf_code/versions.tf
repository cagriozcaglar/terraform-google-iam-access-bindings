# This file is used to specify the required Terraform and provider versions.
terraform {
  # Specifies the required version of Terraform.
  required_version = ">= 1.0"

  # Specifies the required version of the Google Cloud provider.
  required_providers {
    google = {
      # The official HashiCorp Google Cloud provider.
      source  = "hashicorp/google"
      # A version constraint to ensure compatibility.
      version = ">= 4.34.0"
    }
  }
}
