locals {
  # Flatten the bindings map into a list of individual member bindings.
  # This makes it possible to use for_each with the non-authoritative google_*_iam_member resources.
  all_member_bindings = flatten([
    for binding_key, binding_details in var.bindings : [
      for member in binding_details.members : {
        # A unique key for each member binding, used in the for_each of the resources.
        # It's a concatenation of the original key, role, and member.
        unique_key = "${binding_key}--${binding_details.role}--${member}"
        # The original key from the var.bindings map, used for grouping in outputs.
        original_key = binding_key
        # The type of resource (e.g., 'project', 'storage_bucket').
        resource_type = binding_details.resource_type
        # The ID of the resource (e.g., project ID or bucket name).
        resource_id = binding_details.resource_id
        # The IAM role to grant.
        role = binding_details.role
        # The individual member to grant the role to.
        member = member
        # The IAM condition, if any.
        condition = binding_details.condition
      }
    ]
  ])

  # Filter the flattened bindings for projects and create a map keyed by unique_key.
  project_members = {
    for b in local.all_member_bindings : b.unique_key => b if b.resource_type == "project"
  }

  # Filter the flattened bindings for GCS buckets and create a map keyed by unique_key.
  storage_bucket_members = {
    for b in local.all_member_bindings : b.unique_key => b if b.resource_type == "storage_bucket"
  }

  # Filter the flattened bindings for Pub/Sub topics and create a map keyed by unique_key.
  pubsub_topic_members = {
    for b in local.all_member_bindings : b.unique_key => b if b.resource_type == "pubsub_topic"
  }

  # Create a unified map of all created IAM member resources.
  # This makes it easier to process them together for the output.
  all_members = merge(
    google_project_iam_member.project_members,
    google_storage_bucket_iam_member.storage_bucket_members,
    google_pubsub_topic_iam_member.pubsub_topic_members
  )

  # Create a lookup map from a member's unique key to its original binding key.
  # This avoids complex lookups in the final grouping step.
  unique_key_to_original_key_lookup = {
    for b in local.all_member_bindings : b.unique_key => b.original_key
  }

  # Group etags by the original binding key for the output variable.
  # This iterates over the unified map of all created resources.
  all_etags = {
    for unique_key, member_resource in local.all_members :
    local.unique_key_to_original_key_lookup[unique_key] => member_resource.etag...
  }
}

# Additive IAM members for Google Cloud Projects.
resource "google_project_iam_member" "project_members" {
  # The for_each meta-argument creates an instance for each item in the project_members map.
  for_each = local.project_members

  # The project ID to apply the binding to.
  project = each.value.resource_id
  # The role that should be applied.
  role = each.value.role
  # The member to bind to the role.
  member = each.value.member

  # The dynamic block iterates over a complex value and generates a nested block for each element of that value.
  dynamic "condition" {
    # If a condition is defined in the input, create a condition block.
    for_each = each.value.condition != null ? [each.value.condition] : []

    # The content block defines the body of each generated block.
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = condition.value.description
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}

# Additive IAM members for Google Cloud Storage Buckets.
resource "google_storage_bucket_iam_member" "storage_bucket_members" {
  # The for_each meta-argument creates an instance for each item in the storage_bucket_members map.
  for_each = local.storage_bucket_members

  # The name of the bucket to apply the binding to.
  bucket = each.value.resource_id
  # The role that should be applied.
  role = each.value.role
  # The member to bind to the role.
  member = each.value.member

  # The dynamic block iterates over a complex value and generates a nested block for each element of that value.
  dynamic "condition" {
    # If a condition is defined in the input, create a condition block.
    for_each = each.value.condition != null ? [each.value.condition] : []

    # The content block defines the body of each generated block.
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = condition.value.description
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}

# Additive IAM members for Google Cloud Pub/Sub Topics.
resource "google_pubsub_topic_iam_member" "pubsub_topic_members" {
  # The for_each meta-argument creates an instance for each item in the pubsub_topic_members map.
  for_each = local.pubsub_topic_members

  # The full name of the topic to apply the binding to.
  topic = each.value.resource_id
  # The role that should be applied.
  role = each.value.role
  # The member to bind to the role.
  member = each.value.member

  # The dynamic block iterates over a complex value and generates a nested block for each element of that value.
  dynamic "condition" {
    # If a condition is defined in the input, create a condition block.
    for_each = each.value.condition != null ? [each.value.condition] : []

    # The content block defines the body of each generated block.
    content {
      # The title of the condition.
      title = condition.value.title
      # An optional description of the condition.
      description = condition.value.description
      # The CEL expression of the condition.
      expression = condition.value.expression
    }
  }
}
