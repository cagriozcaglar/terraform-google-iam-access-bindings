# Creates IAM bindings at the project level.
resource "google_project_iam_binding" "project" {
  # Iterates over the map of project bindings provided in the input variable.
  for_each = var.project_bindings

  # The ID of the project to which the binding will be applied.
  project = each.value.project
  # The role that will be assigned to the members.
  role = each.value.role
  # A list of principals who will be granted the role.
  members = each.value.members

  # A dynamic block to add a condition to the IAM binding, if specified.
  dynamic "condition" {
    # Creates a condition block only if a condition is defined for the current binding.
    for_each = each.value.condition != null ? [each.value.condition] : []

    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
    }
  }
}

# Creates IAM bindings at the folder level.
resource "google_folder_iam_binding" "folder" {
  # Iterates over the map of folder bindings provided in the input variable.
  for_each = var.folder_bindings

  # The ID of the folder to which the binding will be applied.
  folder = each.value.folder
  # The role that will be assigned to the members.
  role = each.value.role
  # A list of principals who will be granted the role.
  members = each.value.members

  # A dynamic block to add a condition to the IAM binding, if specified.
  dynamic "condition" {
    # Creates a condition block only if a condition is defined for the current binding.
    for_each = each.value.condition != null ? [each.value.condition] : []

    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
    }
  }
}

# Creates IAM bindings at the organization level.
resource "google_organization_iam_binding" "organization" {
  # Iterates over the map of organization bindings provided in the input variable.
  for_each = var.organization_bindings

  # The ID of the organization to which the binding will be applied.
  org_id = each.value.org_id
  # The role that will be assigned to the members.
  role = each.value.role
  # A list of principals who will be granted the role.
  members = each.value.members

  # A dynamic block to add a condition to the IAM binding, if specified.
  dynamic "condition" {
    # Creates a condition block only if a condition is defined for the current binding.
    for_each = each.value.condition != null ? [each.value.condition] : []

    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
    }
  }
}

# Creates IAM bindings at the storage bucket level.
resource "google_storage_bucket_iam_binding" "storage_bucket" {
  # Iterates over the map of storage bucket bindings provided in the input variable.
  for_each = var.storage_bucket_bindings

  # The name of the bucket to which the binding will be applied.
  bucket = each.value.bucket
  # The role that will be assigned to the members.
  role = each.value.role
  # A list of principals who will be granted the role.
  members = each.value.members

  # A dynamic block to add a condition to the IAM binding, if specified.
  dynamic "condition" {
    # Creates a condition block only if a condition is defined for the current binding.
    for_each = each.value.condition != null ? [each.value.condition] : []

    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
    }
  }
}

# Creates IAM bindings at the service account level.
resource "google_service_account_iam_binding" "service_account" {
  # Iterates over the map of service account bindings provided in the input variable.
  for_each = var.service_account_bindings

  # The full name of the service account to which the binding will be applied.
  service_account_id = each.value.service_account_id
  # The role that will be assigned to the members.
  role = each.value.role
  # A list of principals who will be granted the role.
  members = each.value.members

  # A dynamic block to add a condition to the IAM binding, if specified.
  dynamic "condition" {
    # Creates a condition block only if a condition is defined for the current binding.
    for_each = each.value.condition != null ? [each.value.condition] : []

    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = lookup(condition.value, "description", null)
    }
  }
}
