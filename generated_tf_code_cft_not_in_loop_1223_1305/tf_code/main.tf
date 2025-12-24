# The main.tf file contains the core logic of the module.
# It defines the resources that the module will create and manage.
# This module creates IAM bindings for various GCP resources based on the provided inputs.

locals {
  # A binding can only be created if a role is specified and members are provided.
  can_create_binding = var.role != null && length(var.members) > 0
}

# Creates an IAM binding for a Google Cloud project.
# This resource is only created if the `project` variable is provided and a binding is possible.
resource "google_project_iam_binding" "project_binding" {
  # Controls the creation of the resource. If var.project is provided and a binding is possible, this resource will be created.
  count = var.project != null && local.can_create_binding ? 1 : 0

  # The ID of the project to which the IAM binding will be applied.
  project = var.project

  # The IAM role to be granted.
  role = var.role

  # The list of members to be granted the role.
  members = var.members

  # A dynamic block to create a condition for the IAM binding if one is provided.
  dynamic "condition" {
    # Iterates over the condition variable. If it's null, the loop is empty and no block is created.
    for_each = var.condition != null ? [var.condition] : []

    # The content of the condition block.
    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = condition.value.description
    }
  }
}

# Creates an IAM binding for a Google Cloud Storage bucket.
# This resource is only created if the `bucket` variable is provided and a binding is possible.
resource "google_storage_bucket_iam_binding" "bucket_binding" {
  # Controls the creation of the resource. If var.bucket is provided and a binding is possible, this resource will be created.
  count = var.bucket != null && local.can_create_binding ? 1 : 0

  # The name of the GCS bucket to which the IAM binding will be applied.
  bucket = var.bucket

  # The IAM role to be granted.
  role = var.role

  # The list of members to be granted the role.
  members = var.members

  # A dynamic block to create a condition for the IAM binding if one is provided.
  dynamic "condition" {
    # Iterates over the condition variable. If it's null, the loop is empty and no block is created.
    for_each = var.condition != null ? [var.condition] : []

    # The content of the condition block.
    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = condition.value.description
    }
  }
}

# Creates an IAM binding for a Google Cloud Service Account.
# This resource is only created if the `service_account_id` variable is provided and a binding is possible.
resource "google_service_account_iam_binding" "sa_binding" {
  # Controls the creation of the resource. If var.service_account_id is provided and a binding is possible, this resource will be created.
  count = var.service_account_id != null && local.can_create_binding ? 1 : 0

  # The fully-qualified ID of the service account to which the IAM binding will be applied.
  service_account_id = var.service_account_id

  # The IAM role to be granted.
  role = var.role

  # The list of members to be granted the role.
  members = var.members

  # A dynamic block to create a condition for the IAM binding if one is provided.
  dynamic "condition" {
    # Iterates over the condition variable. If it's null, the loop is empty and no block is created.
    for_each = var.condition != null ? [var.condition] : []

    # The content of the condition block.
    content {
      # The title of the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = condition.value.description
    }
  }
}
