# This module manages authoritative and non-authoritative IAM policies for various Google Cloud resources.
# It allows specifying both `iam_binding` and `iam_member` policies for projects, folders, organizations,
# storage buckets, Pub/Sub topics, and service accounts. Using `iam_binding` is authoritative and will
# overwrite any existing members for a specific role on a resource. Using `iam_member` is non-authoritative
# and will add a member to a role without affecting other members.

data "google_client_config" "current" {}

locals {
  # Create maps for binding outputs, keyed by the logical name from the input variables.
  folder_bindings_output = {
    for binding_key, binding_details in var.folder_bindings : binding_key =>
    try(google_folder_iam_binding.main["${binding_details.folder}|${binding_details.role}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"], null)
  }

  # Flatten the folder_members map.
  folder_members_flat = flatten([
    for binding_key, binding_details in var.folder_members : [
      for member in binding_details.members : {
        key       = "${binding_details.folder}|${binding_details.role}|${member}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"
        folder    = binding_details.folder
        role      = binding_details.role
        member    = member
        condition = binding_details.condition
      }
    ]
  ])

  # Create maps for binding outputs, keyed by the logical name from the input variables.
  organization_bindings_output = {
    for binding_key, binding_details in var.organization_bindings : binding_key =>
    try(google_organization_iam_binding.main["${binding_details.org_id}|${binding_details.role}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"], null)
  }

  # Flatten the organization_members map.
  organization_members_flat = flatten([
    for binding_key, binding_details in var.organization_members : [
      for member in binding_details.members : {
        key       = "${binding_details.org_id}|${binding_details.role}|${member}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"
        org_id    = binding_details.org_id
        role      = binding_details.role
        member    = member
        condition = binding_details.condition
      }
    ]
  ])

  # Create maps for binding outputs, keyed by the logical name from the input variables.
  project_bindings_output = {
    for binding_key, binding_details in var.project_bindings : binding_key =>
    try(google_project_iam_binding.main["${coalesce(binding_details.project, data.google_client_config.current.project)}|${binding_details.role}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"], null)
  }

  # Flatten the project_members map to create a list of individual members for resource creation.
  # The key is designed to be unique for each member on a specific role and resource, including condition.
  project_members_flat = flatten([
    for binding_key, binding_details in var.project_members : [
      for member in binding_details.members : {
        key       = "${coalesce(binding_details.project, data.google_client_config.current.project)}|${binding_details.role}|${member}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"
        project   = binding_details.project
        role      = binding_details.role
        member    = member
        condition = binding_details.condition
      }
    ]
  ])

  # Create maps for binding outputs, keyed by the logical name from the input variables.
  pubsub_topic_bindings_output = {
    for binding_key, binding_details in var.pubsub_topic_bindings : binding_key =>
    try(google_pubsub_topic_iam_binding.main["${coalesce(binding_details.project, data.google_client_config.current.project)}|${binding_details.topic}|${binding_details.role}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"], null)
  }

  # Flatten the pubsub_topic_members map.
  pubsub_topic_members_flat = flatten([
    for binding_key, binding_details in var.pubsub_topic_members : [
      for member in binding_details.members : {
        key       = "${coalesce(binding_details.project, data.google_client_config.current.project)}|${binding_details.topic}|${binding_details.role}|${member}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"
        project   = binding_details.project
        topic     = binding_details.topic
        role      = binding_details.role
        member    = member
        condition = binding_details.condition
      }
    ]
  ])

  # Create maps for binding outputs, keyed by the logical name from the input variables.
  service_account_bindings_output = {
    for binding_key, binding_details in var.service_account_bindings : binding_key =>
    try(google_service_account_iam_binding.main["${binding_details.service_account_id}|${binding_details.role}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"], null)
  }

  # Flatten the service_account_members map.
  service_account_members_flat = flatten([
    for binding_key, binding_details in var.service_account_members : [
      for member in binding_details.members : {
        key                = "${binding_details.service_account_id}|${binding_details.role}|${member}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"
        service_account_id = binding_details.service_account_id
        role               = binding_details.role
        member             = member
        condition          = binding_details.condition
      }
    ]
  ])

  # Create maps for binding outputs, keyed by the logical name from the input variables.
  storage_bucket_bindings_output = {
    for binding_key, binding_details in var.storage_bucket_bindings : binding_key =>
    try(google_storage_bucket_iam_binding.main["${binding_details.bucket}|${binding_details.role}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"], null)
  }

  # Flatten the storage_bucket_members map.
  storage_bucket_members_flat = flatten([
    for binding_key, binding_details in var.storage_bucket_members : [
      for member in binding_details.members : {
        key       = "${binding_details.bucket}|${binding_details.role}|${member}|${binding_details.condition == null ? "no_condition" : md5(jsonencode(binding_details.condition))}"
        bucket    = binding_details.bucket
        role      = binding_details.role
        member    = member
        condition = binding_details.condition
      }
    ]
  ])
}

# Authoritative Folder IAM Bindings
resource "google_folder_iam_binding" "main" {
  for_each = {
    for k, v in var.folder_bindings : "${v.folder}|${v.role}|${v.condition == null ? "no_condition" : md5(jsonencode(v.condition))}" => v
  }

  # The folder to apply the IAM policies to.
  folder = each.value.folder
  # The role that should be applied.
  role = each.value.role
  # A set of users, service accounts, and groups to assign the role to.
  members = each.value.members

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Non-authoritative Folder IAM Members
resource "google_folder_iam_member" "main" {
  for_each = { for v in local.folder_members_flat : v.key => v }

  # The folder to apply the IAM policies to.
  folder = each.value.folder
  # The role that should be applied.
  role = each.value.role
  # The member to assign the role to.
  member = each.value.member

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Authoritative Organization IAM Bindings
resource "google_organization_iam_binding" "main" {
  for_each = {
    for k, v in var.organization_bindings : "${v.org_id}|${v.role}|${v.condition == null ? "no_condition" : md5(jsonencode(v.condition))}" => v
  }

  # The numeric ID of the organization in non-prefix form (e.g. '1234567890').
  org_id = each.value.org_id
  # The role that should be applied.
  role = each.value.role
  # A set of users, service accounts, and groups to assign the role to.
  members = each.value.members

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Non-authoritative Organization IAM Members
resource "google_organization_iam_member" "main" {
  for_each = { for v in local.organization_members_flat : v.key => v }

  # The numeric ID of the organization in non-prefix form (e.g. '1234567890').
  org_id = each.value.org_id
  # The role that should be applied.
  role = each.value.role
  # The member to assign the role to.
  member = each.value.member

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Authoritative Project IAM Bindings
resource "google_project_iam_binding" "main" {
  for_each = {
    for k, v in var.project_bindings : "${coalesce(v.project, data.google_client_config.current.project)}|${v.role}|${v.condition == null ? "no_condition" : md5(jsonencode(v.condition))}" => v
  }

  # (Optional) The project to apply the IAM policies to. If not provided, the provider project is used.
  project = each.value.project
  # The role that should be applied.
  role = each.value.role
  # A set of users, service accounts, and groups to assign the role to.
  members = each.value.members

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Non-authoritative Project IAM Members
resource "google_project_iam_member" "main" {
  for_each = { for v in local.project_members_flat : v.key => v }

  # (Optional) The project to apply the IAM policies to. If not provided, the provider project is used.
  project = each.value.project
  # The role that should be applied.
  role = each.value.role
  # The member to assign the role to.
  member = each.value.member

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Authoritative Pub/Sub Topic IAM Bindings
resource "google_pubsub_topic_iam_binding" "main" {
  for_each = {
    for k, v in var.pubsub_topic_bindings : "${coalesce(v.project, data.google_client_config.current.project)}|${v.topic}|${v.role}|${v.condition == null ? "no_condition" : md5(jsonencode(v.condition))}" => v
  }

  # (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
  project = each.value.project
  # The topic name or id to bind to.
  topic = each.value.topic
  # The role that should be applied.
  role = each.value.role
  # A set of users, service accounts, and groups to assign the role to.
  members = each.value.members

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Non-authoritative Pub/Sub Topic IAM Members
resource "google_pubsub_topic_iam_member" "main" {
  for_each = { for v in local.pubsub_topic_members_flat : v.key => v }

  # (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
  project = each.value.project
  # The topic name or id to bind to.
  topic = each.value.topic
  # The role that should be applied.
  role = each.value.role
  # The member to assign the role to.
  member = each.value.member

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Authoritative Service Account IAM Bindings
resource "google_service_account_iam_binding" "main" {
  for_each = {
    for k, v in var.service_account_bindings : "${v.service_account_id}|${v.role}|${v.condition == null ? "no_condition" : md5(jsonencode(v.condition))}" => v
  }

  # The fully-qualified name of the service account to apply policy to.
  service_account_id = each.value.service_account_id
  # The role that should be applied.
  role = each.value.role
  # A set of users, service accounts, and groups to assign the role to.
  members = each.value.members

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Non-authoritative Service Account IAM Members
resource "google_service_account_iam_member" "main" {
  for_each = { for v in local.service_account_members_flat : v.key => v }

  # The fully-qualified name of the service account to apply policy to.
  service_account_id = each.value.service_account_id
  # The role that should be applied.
  role = each.value.role
  # The member to assign the role to.
  member = each.value.member

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Authoritative Storage Bucket IAM Bindings
resource "google_storage_bucket_iam_binding" "main" {
  for_each = {
    for k, v in var.storage_bucket_bindings : "${v.bucket}|${v.role}|${v.condition == null ? "no_condition" : md5(jsonencode(v.condition))}" => v
  }

  # The name of the bucket.
  bucket = each.value.bucket
  # The role that should be applied.
  role = each.value.role
  # A set of users, service accounts, and groups to assign the role to.
  members = each.value.members

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}

# Non-authoritative Storage Bucket IAM Members
resource "google_storage_bucket_iam_member" "main" {
  for_each = { for v in local.storage_bucket_members_flat : v.key => v }

  # The name of the bucket.
  bucket = each.value.bucket
  # The role that should be applied.
  role = each.value.role
  # The member to assign the role to.
  member = each.value.member

  # (Optional) An IAM condition block.
  dynamic "condition" {
    for_each = each.value.condition != null ? [each.value.condition] : []
    content {
      # The title for the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = try(condition.value.description, null)
      # The expression specifies the condition for the role binding.
      expression = condition.value.expression
    }
  }
}
