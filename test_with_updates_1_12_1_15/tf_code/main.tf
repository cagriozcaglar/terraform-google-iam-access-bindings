# This local block filters the input `bindings` map into separate maps for each supported resource type.
# This allows using `for_each` to create resources of a specific type from a heterogeneous input map.
locals {
  # Filters for bindings that target a project.
  project_bindings = {
    for k, v in var.bindings : k => v if v.project != null
  }

  # Filters for bindings that target a folder.
  folder_bindings = {
    for k, v in var.bindings : k => v if v.folder != null
  }

  # Filters for bindings that target an organization.
  organization_bindings = {
    for k, v in var.bindings : k => v if v.organization != null
  }

  # Filters for bindings that target a Cloud Storage bucket.
  bucket_bindings = {
    for k, v in var.bindings : k => v if v.bucket != null
  }
}

# Creates IAM bindings at the project level.
resource "google_project_iam_binding" "project" {
  # Iterates over the filtered map of project-level bindings.
  for_each = local.project_bindings

  # The project ID to which the binding applies.
  project = each.value.project
  # The role that is assigned to the members.
  role    = each.value.role
  # Identities that will be granted the privilege of the role.
  members = each.value.members

  # Dynamically adds a condition block if one is specified in the input.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = condition.value.description
      # The CEL expression to evaluate.
      expression = condition.value.expression
    }
  }
}

# Creates IAM bindings at the folder level.
resource "google_folder_iam_binding" "folder" {
  # Iterates over the filtered map of folder-level bindings.
  for_each = local.folder_bindings

  # The folder ID (e.g., 'folders/12345') to which the binding applies.
  folder  = each.value.folder
  # The role that is assigned to the members.
  role    = each.value.role
  # Identities that will be granted the privilege of the role.
  members = each.value.members

  # Dynamically adds a condition block if one is specified in the input.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = condition.value.description
      # The CEL expression to evaluate.
      expression = condition.value.expression
    }
  }
}

# Creates IAM bindings at the organization level.
resource "google_organization_iam_binding" "organization" {
  # Iterates over the filtered map of organization-level bindings.
  for_each = local.organization_bindings

  # The numeric organization ID to which the binding applies.
  org_id  = each.value.organization
  # The role that is assigned to the members.
  role    = each.value.role
  # Identities that will be granted the privilege of the role.
  members = each.value.members

  # Dynamically adds a condition block if one is specified in the input.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = condition.value.description
      # The CEL expression to evaluate.
      expression = condition.value.expression
    }
  }
}

# Creates IAM bindings for a Cloud Storage bucket.
resource "google_storage_bucket_iam_binding" "bucket" {
  # Iterates over the filtered map of bucket-level bindings.
  for_each = local.bucket_bindings

  # The name of the bucket to which the binding applies.
  bucket  = each.value.bucket
  # The role that is assigned to the members.
  role    = each.value.role
  # Identities that will be granted the privilege of the role.
  members = each.value.members

  # Dynamically adds a condition block if one is specified in the input.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = condition.value.description
      # The CEL expression to evaluate.
      expression = condition.value.expression
    }
  }
}
