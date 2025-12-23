# Flattens the nested input maps into lists of objects suitable for `for_each`.
# Each object in the flattened list represents a single IAM member binding for a specific resource.
locals {
  # Flattens the project_bindings variable into a list of individual role members.
  # This transformation is necessary to use the non-authoritative `google_project_iam_member` resource,
  # which manages one member at a time. A unique key is generated for each binding
  # to be used as the `for_each` identifier.
  flat_project_members = flatten([
    for project_id, roles in var.project_bindings : [
      for role, binding in roles : [
        for member in binding.members : {
          project   = project_id
          role      = role
          member    = member
          condition = binding.condition
          key       = "${replace(project_id, "/", "_")}-${replace(role, "/", "_")}-${urlencode(member)}"
        }
      ]
    ]
  ])

  # Flattens the service_account_bindings variable into a list of individual role members.
  # This structure is used to iterate and create `google_service_account_iam_member` resources.
  flat_service_account_members = flatten([
    for sa_id, roles in var.service_account_bindings : [
      for role, binding in roles : [
        for member in binding.members : {
          service_account_id = sa_id
          role               = role
          member             = member
          condition          = binding.condition
          key                = "${replace(sa_id, "/", "_")}-${replace(role, "/", "_")}-${urlencode(member)}"
        }
      ]
    ]
  ])

  # Flattens the storage_bucket_bindings variable into a list of individual role members.
  # This structure is used to iterate and create `google_storage_bucket_iam_member` resources.
  flat_storage_bucket_members = flatten([
    for bucket_name, roles in var.storage_bucket_bindings : [
      for role, binding in roles : [
        for member in binding.members : {
          bucket    = bucket_name
          role      = role
          member    = member
          condition = binding.condition
          key       = "${bucket_name}-${replace(role, "/", "_")}-${urlencode(member)}"
        }
      ]
    ]
  ])
}

# Manages non-authoritative IAM member bindings for Google Cloud projects.
# This resource grants a single role to a single member, leaving other bindings untouched.
resource "google_project_iam_member" "project" {
  # Creates a resource instance for each unique project-role-member combination.
  for_each = { for m in local.flat_project_members : m.key => m }

  # The ID of the project to which the IAM member is to be added.
  project = each.value.project
  # The IAM role to be granted to the member.
  role = each.value.role
  # The member to be granted the role (e.g., `user:foo@example.com`).
  member = each.value.member

  # A dynamic block to set the IAM condition, if one is provided.
  dynamic "condition" {
    # Iterates over the condition object if it's not null, creating the condition block.
    for_each = each.value.condition == null ? [] : [each.value.condition]

    # The content of the dynamic block.
    content {
      # The title for the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = try(condition.value.description, null)
    }
  }
}

# Manages non-authoritative IAM member bindings for Google Cloud Service Accounts.
# This resource grants a single role to a single member on a service account.
resource "google_service_account_iam_member" "service_account" {
  # Creates a resource instance for each unique service_account-role-member combination.
  for_each = { for m in local.flat_service_account_members : m.key => m }

  # The full resource ID of the service account to which the IAM member is added.
  service_account_id = each.value.service_account_id
  # The IAM role to be granted to the member.
  role = each.value.role
  # The member to be granted the role.
  member = each.value.member

  # A dynamic block to set the IAM condition, if one is provided.
  dynamic "condition" {
    # Iterates over the condition object if it's not null, creating the condition block.
    for_each = each.value.condition == null ? [] : [each.value.condition]

    # The content of the dynamic block.
    content {
      # The title for the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = try(condition.value.description, null)
    }
  }
}

# Manages non-authoritative IAM member bindings for Google Cloud Storage buckets.
# This resource grants a single role to a single member on a storage bucket.
resource "google_storage_bucket_iam_member" "storage_bucket" {
  # Creates a resource instance for each unique bucket-role-member combination.
  for_each = { for m in local.flat_storage_bucket_members : m.key => m }

  # The name of the GCS bucket to which the IAM member is added.
  bucket = each.value.bucket
  # The IAM role to be granted to the member.
  role = each.value.role
  # The member to be granted the role.
  member = each.value.member

  # A dynamic block to set the IAM condition, if one is provided.
  dynamic "condition" {
    # Iterates over the condition object if it's not null, creating the condition block.
    for_each = each.value.condition == null ? [] : [each.value.condition]

    # The content of the dynamic block.
    content {
      # The title for the condition.
      title = condition.value.title
      # The Common Expression Language (CEL) expression that specifies the condition.
      expression = condition.value.expression
      # An optional description of the condition.
      description = try(condition.value.description, null)
    }
  }
}
