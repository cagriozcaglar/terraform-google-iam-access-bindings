# The versions.tf file is used to specify the required Terraform and provider versions.
# It is a best practice to pin versions to ensure that your code is not affected by breaking changes in future releases.
terraform {
  # This module is designed to work with Terraform 1.0 and later.
  required_version = ">= 1.0"

  # This module uses the Google Provider to manage Google Cloud resources.
  # We are pinning the provider version to ~> 5.0 to ensure compatibility.
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
