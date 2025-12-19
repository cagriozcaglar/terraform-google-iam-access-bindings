# This file contains the main logic for creating IAM bindings.
# It uses a single map variable to dynamically create bindings for different resource types.

# IAM Access Bindings Module
#
# This module provides a generic and reusable way to manage authoritative IAM bindings
# for various Google Cloud resources. It uses a map-based input to create
# `google_*_iam_binding` resources, which are authoritative and will overwrite any
# existing members for a given role on a specific resource. This approach is ideal
# for managing a complete and definitive set of members for specific roles.
#
# Supported resource types:
# - project
# - storage_bucket
# - service_account

locals {
  # Filter the input `bindings` map to create separate maps for each supported resource type.
  # This allows using a clean for_each loop on the respective resource blocks.

  # Filters for bindings where the type is 'project'.
  project_bindings = {
    for k, v in var.bindings : k => v if v.type == "project"
  }

  # Filters for bindings where the type is 'storage_bucket'.
  storage_bucket_bindings = {
    for k, v in var.bindings : k => v if v.type == "storage_bucket"
  }

  # Filters for bindings where the type is 'service_account'.
  service_account_bindings = {
    for k, v in var.bindings : k => v if v.type == "service_account"
  }
}

# Creates authoritative IAM bindings at the project level.
# This resource is authoritative and will overwrite any existing members for the specified role on the project.
resource "google_project_iam_binding" "project_binding" {
  # Iterates over the filtered map of project-level bindings.
  for_each = local.project_bindings

  # The GCP project ID where the IAM binding will be applied.
  project = each.value.id
  # The role that should be applied. For example, `roles/editor`.
  role = each.value.role
  # A list of members who should be granted the role. Each member must be prefixed with its type (e.g., 'user:', 'group:', 'serviceAccount:').
  members = each.value.members
}

# Creates authoritative IAM bindings on a Google Cloud Storage bucket.
# This resource is authoritative and will overwrite any existing members for the specified role on the bucket.
resource "google_storage_bucket_iam_binding" "storage_bucket_binding" {
  # Iterates over the filtered map of storage bucket-level bindings.
  for_each = local.storage_bucket_bindings

  # The name of the GCS bucket where the IAM binding will be applied.
  bucket = each.value.id
  # The role that should be applied. For example, `roles/storage.objectAdmin`.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members
}

# Creates authoritative IAM bindings on a Google Cloud Service Account.
# This is commonly used to grant other principals the ability to impersonate the service account.
# This resource is authoritative and will overwrite any existing members for the specified role on the service account.
resource "google_service_account_iam_binding" "service_account_binding" {
  # Iterates over the filtered map of service account-level bindings.
  for_each = local.service_account_bindings

  # The full email address of the service account where the IAM binding will be applied.
  service_account_id = each.value.id
  # The role that should be applied. For example, `roles/iam.serviceAccountTokenCreator`.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members
}
