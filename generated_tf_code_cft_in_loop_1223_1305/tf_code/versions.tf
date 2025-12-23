terraform {
  # Specifies the minimum version of Terraform required to apply this configuration.
  required_version = ">= 1.0"
  # Specifies the required providers and their version constraints.
  required_providers {
    # Specifies the Google Cloud Platform provider.
    google = {
      # The official HashiCorp Google Cloud Platform provider.
      source  = "hashicorp/google"
      # The minimum version of the Google provider required.
      version = ">= 4.51.0"
    }
  }
}
