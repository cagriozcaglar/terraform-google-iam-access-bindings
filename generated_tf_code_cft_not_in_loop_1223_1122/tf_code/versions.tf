# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
terraform {
  # This module is meant for use with Terraform 1.3+
  required_version = ">= 1.3"

  # This module supports the Google Provider.
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}
