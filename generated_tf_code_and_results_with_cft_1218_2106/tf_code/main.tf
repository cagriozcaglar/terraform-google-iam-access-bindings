# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

/**
 * This module manages authoritative IAM bindings for various Google Cloud resource types.
 * An IAM binding is authoritative for a given role, meaning it will overwrite any
 * existing members for that role on the resource. If you want to add a member to a role
 * without affecting existing members, use the `IAM_Access_Members` component instead.
 *
 * This module supports creating bindings at the following levels:
 * - Project
 * - Folder
 * - Organization
 * - Billing Account
 * - Service Account
 * - Storage Bucket
 */

# Project level IAM bindings
resource "google_project_iam_binding" "project_bindings" {
  # Creates a binding for each entry in the var.project_bindings map.
  for_each = var.project_bindings

  # The project to apply the IAM binding to.
  project = each.value.project
  # The role that should be applied.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members

  # Optional condition block for the binding.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}

# Folder level IAM bindings
resource "google_folder_iam_binding" "folder_bindings" {
  # Creates a binding for each entry in the var.folder_bindings map.
  for_each = var.folder_bindings

  # The folder to apply the IAM binding to.
  folder = each.value.folder
  # The role that should be applied.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members

  # Optional condition block for the binding.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}

# Organization level IAM bindings
resource "google_organization_iam_binding" "organization_bindings" {
  # Creates a binding for each entry in the var.organization_bindings map.
  for_each = var.organization_bindings

  # The organization to apply the IAM binding to.
  org_id = each.value.org_id
  # The role that should be applied.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members

  # Optional condition block for the binding.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}

# Billing Account level IAM bindings
resource "google_billing_account_iam_binding" "billing_account_bindings" {
  # Creates a binding for each entry in the var.billing_account_bindings map.
  for_each = var.billing_account_bindings

  # The billing account to apply the IAM binding to.
  billing_account_id = each.value.billing_account_id
  # The role that should be applied.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members

  # Optional condition block for the binding.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}

# Service Account level IAM bindings
resource "google_service_account_iam_binding" "service_account_bindings" {
  # Creates a binding for each entry in the var.service_account_bindings map.
  for_each = var.service_account_bindings

  # The service account to apply the IAM binding to. The ID must be in the form `projects/{project}/serviceAccounts/{email}`.
  service_account_id = each.value.service_account_id
  # The role that should be applied.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members

  # Optional condition block for the binding.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}

# Storage Bucket level IAM bindings
resource "google_storage_bucket_iam_binding" "storage_bucket_bindings" {
  # Creates a binding for each entry in the var.storage_bucket_bindings map.
  for_each = var.storage_bucket_bindings

  # The storage bucket to apply the IAM binding to.
  bucket = "gs://${each.value.bucket}"
  # The role that should be applied.
  role = each.value.role
  # A list of members who should be granted the role.
  members = each.value.members

  # Optional condition block for the binding.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}
