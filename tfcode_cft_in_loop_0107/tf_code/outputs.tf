output "folder_bindings" {
  description = "A map of the created folder-level IAM bindings, keyed by the logical name provided in the input variable."
  value = {
    for k, v in local.folder_bindings_output : k => {
      folder  = v.folder
      role    = v.role
      members = v.members
      etag    = v.etag
    } if v != null
  }
}

output "folder_members" {
  description = "A map of the created folder-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag."
  value = {
    for role_key, role_details in var.folder_members : role_key => {
      folder = role_details.folder,
      role   = role_details.role,
      members = {
        for member in role_details.members : member => {
          etag = try(google_folder_iam_member.main["${role_details.folder}|${role_details.role}|${member}|${role_details.condition == null ? "no_condition" : md5(jsonencode(role_details.condition))}"].etag, null)
        }
      }
    }
  }
}

output "organization_bindings" {
  description = "A map of the created organization-level IAM bindings, keyed by the logical name provided in the input variable."
  value = {
    for k, v in local.organization_bindings_output : k => {
      org_id  = v.org_id
      role    = v.role
      members = v.members
      etag    = v.etag
    } if v != null
  }
}

output "organization_members" {
  description = "A map of the created organization-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag."
  value = {
    for role_key, role_details in var.organization_members : role_key => {
      org_id = role_details.org_id,
      role   = role_details.role,
      members = {
        for member in role_details.members : member => {
          etag = try(google_organization_iam_member.main["${role_details.org_id}|${role_details.role}|${member}|${role_details.condition == null ? "no_condition" : md5(jsonencode(role_details.condition))}"].etag, null)
        }
      }
    }
  }
}

output "project_bindings" {
  description = "A map of the created project-level IAM bindings, keyed by the logical name provided in the input variable."
  value = {
    for k, v in local.project_bindings_output : k => {
      project = v.project
      role    = v.role
      members = v.members
      etag    = v.etag
    } if v != null
  }
}

output "project_members" {
  description = "A map of the created project-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag."
  value = {
    for role_key, role_details in var.project_members : role_key => {
      project = coalesce(role_details.project, data.google_client_config.current.project)
      role    = role_details.role
      members = {
        for member in role_details.members : member => {
          etag = try(google_project_iam_member.main["${coalesce(role_details.project, data.google_client_config.current.project)}|${role_details.role}|${member}|${role_details.condition == null ? "no_condition" : md5(jsonencode(role_details.condition))}"].etag, null)
        }
      }
    }
  }
}

output "pubsub_topic_bindings" {
  description = "A map of the created Pub/Sub topic-level IAM bindings, keyed by the logical name provided in the input variable."
  value = {
    for k, v in local.pubsub_topic_bindings_output : k => {
      project = v.project
      topic   = v.topic
      role    = v.role
      members = v.members
      etag    = v.etag
    } if v != null
  }
}

output "pubsub_topic_members" {
  description = "A map of the created Pub/Sub topic-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag."
  value = {
    for role_key, role_details in var.pubsub_topic_members : role_key => {
      project = coalesce(role_details.project, data.google_client_config.current.project)
      topic   = role_details.topic
      role    = role_details.role
      members = {
        for member in role_details.members : member => {
          etag = try(google_pubsub_topic_iam_member.main["${coalesce(role_details.project, data.google_client_config.current.project)}|${role_details.topic}|${role_details.role}|${member}|${role_details.condition == null ? "no_condition" : md5(jsonencode(role_details.condition))}"].etag, null)
        }
      }
    }
  }
}

output "service_account_bindings" {
  description = "A map of the created service account-level IAM bindings, keyed by the logical name provided in the input variable."
  value = {
    for k, v in local.service_account_bindings_output : k => {
      service_account_id = v.service_account_id
      role               = v.role
      members            = v.members
      etag               = v.etag
    } if v != null
  }
}

output "service_account_members" {
  description = "A map of the created service account-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag."
  value = {
    for role_key, role_details in var.service_account_members : role_key => {
      service_account_id = role_details.service_account_id,
      role               = role_details.role,
      members = {
        for member in role_details.members : member => {
          etag = try(google_service_account_iam_member.main["${role_details.service_account_id}|${role_details.role}|${member}|${role_details.condition == null ? "no_condition" : md5(jsonencode(role_details.condition))}"].etag, null)
        }
      }
    }
  }
}

output "storage_bucket_bindings" {
  description = "A map of the created storage bucket-level IAM bindings, keyed by the logical name provided in the input variable."
  value = {
    for k, v in local.storage_bucket_bindings_output : k => {
      bucket  = v.bucket
      role    = v.role
      members = v.members
      etag    = v.etag
    } if v != null
  }
}

output "storage_bucket_members" {
  description = "A map of the created storage bucket-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag."
  value = {
    for role_key, role_details in var.storage_bucket_members : role_key => {
      bucket = role_details.bucket,
      role   = role_details.role,
      members = {
        for member in role_details.members : member => {
          etag = try(google_storage_bucket_iam_member.main["${role_details.bucket}|${role_details.role}|${member}|${role_details.condition == null ? "no_condition" : md5(jsonencode(role_details.condition))}"].etag, null)
        }
      }
    }
  }
}
