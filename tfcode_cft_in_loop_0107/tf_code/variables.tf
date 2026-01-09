variable "folder_bindings" {
  description = "A map of authoritative folder-level IAM bindings to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Authoritative bindings overwrite any existing members for the given role. An empty map can be provided to create no bindings. Be cautious not to manage the same role with both `folder_bindings` and `folder_members` for the same folder, as it can lead to state thrashing."
  type = map(object({
    folder  = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.folder_bindings) : regex("^folders/[0-9]+$", v.folder)])
    error_message = "The folder attribute in folder_bindings must be in the format 'folders/{folder_id}'."
  }
  validation {
    condition     = alltrue([for v in values(var.folder_bindings) : length(v.members) > 0])
    error_message = "The members set for any binding in folder_bindings cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.folder_bindings) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.folder_bindings) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "folder_members" {
  description = "A map of non-authoritative folder-level IAM members to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Non-authoritative members will be added to a role without overwriting existing ones. An empty map can be provided to create no members. Be cautious not to manage the same role with both `folder_bindings` and `folder_members` for the same folder, as it can lead to state thrashing."
  type = map(object({
    folder  = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.folder_members) : regex("^folders/[0-9]+$", v.folder)])
    error_message = "The folder attribute in folder_members must be in the format 'folders/{folder_id}'."
  }
  validation {
    condition     = alltrue([for v in values(var.folder_members) : length(v.members) > 0])
    error_message = "The members set for any entry in folder_members cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.folder_members) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.folder_members) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "organization_bindings" {
  description = "A map of authoritative organization-level IAM bindings to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Authoritative bindings overwrite any existing members for the given role. An empty map can be provided to create no bindings. Be cautious not to manage the same role with both `organization_bindings` and `organization_members` for the same organization, as it can lead to state thrashing."
  type = map(object({
    org_id  = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.organization_bindings) : regex("^[0-9]+$", v.org_id)])
    error_message = "The org_id attribute in organization_bindings must be a numeric string."
  }
  validation {
    condition     = alltrue([for v in values(var.organization_bindings) : length(v.members) > 0])
    error_message = "The members set for any binding in organization_bindings cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.organization_bindings) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.organization_bindings) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "organization_members" {
  description = "A map of non-authoritative organization-level IAM members to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Non-authoritative members will be added to a role without overwriting existing ones. An empty map can be provided to create no members. Be cautious not to manage the same role with both `organization_bindings` and `organization_members` for the same organization, as it can lead to state thrashing."
  type = map(object({
    org_id  = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.organization_members) : regex("^[0-9]+$", v.org_id)])
    error_message = "The org_id attribute in organization_members must be a numeric string."
  }
  validation {
    condition     = alltrue([for v in values(var.organization_members) : length(v.members) > 0])
    error_message = "The members set for any entry in organization_members cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.organization_members) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.organization_members) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "project_bindings" {
  description = "A map of authoritative project-level IAM bindings to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Authoritative bindings overwrite any existing members for the given role. An empty map can be provided to create no bindings. Be cautious not to manage the same role with both `project_bindings` and `project_members` for the same project, as it can lead to state thrashing."
  type = map(object({
    project = optional(string)
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.project_bindings) : v.project == null ? true : can(regex("^[a-z]([-a-z0-9]{4,28}[a-z0-9])$", v.project))])
    error_message = "A project ID must be a unique string of 6 to 30 lowercase letters, digits, or hyphens. It must start with a letter, and cannot have a trailing hyphen."
  }
  validation {
    condition     = alltrue([for v in values(var.project_bindings) : length(v.members) > 0])
    error_message = "The members set for any binding in project_bindings cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.project_bindings) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.project_bindings) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "project_members" {
  description = "A map of non-authoritative project-level IAM members to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Non-authoritative members will be added to a role without overwriting existing ones. An empty map can be provided to create no members. Be cautious not to manage the same role with both `project_bindings` and `project_members` for the same project, as it can lead to state thrashing."
  type = map(object({
    project = optional(string)
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.project_members) : v.project == null ? true : can(regex("^[a-z]([-a-z0-9]{4,28}[a-z0-9])$", v.project))])
    error_message = "A project ID must be a unique string of 6 to 30 lowercase letters, digits, or hyphens. It must start with a letter, and cannot have a trailing hyphen."
  }
  validation {
    condition     = alltrue([for v in values(var.project_members) : length(v.members) > 0])
    error_message = "The members set for any entry in project_members cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.project_members) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.project_members) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "pubsub_topic_bindings" {
  description = "A map of authoritative Pub/Sub topic-level IAM bindings to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Authoritative bindings overwrite any existing members for the given role. An empty map can be provided to create no bindings. Be cautious not to manage the same role with both `pubsub_topic_bindings` and `pubsub_topic_members` for the same topic, as it can lead to state thrashing."
  type = map(object({
    project = optional(string)
    topic   = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_bindings) : can(regex("^[a-zA-Z][a-zA-Z0-9-._~]{2,254}$", v.topic))])
    error_message = "A topic ID must be between 3 and 255 characters, start with a letter, and contain only letters, numbers, hyphens, periods, underscores, and tildes."
  }
  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_bindings) : length(v.members) > 0])
    error_message = "The members set for any binding in pubsub_topic_bindings cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_bindings) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_bindings) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "pubsub_topic_members" {
  description = "A map of non-authoritative Pub/Sub topic-level IAM members to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Non-authoritative members will be added to a role without overwriting existing ones. An empty map can be provided to create no members. Be cautious not to manage the same role with both `pubsub_topic_bindings` and `pubsub_topic_members` for the same topic, as it can lead to state thrashing."
  type = map(object({
    project = optional(string)
    topic   = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_members) : can(regex("^[a-zA-Z][a-zA-Z0-9-._~]{2,254}$", v.topic))])
    error_message = "A topic ID must be between 3 and 255 characters, start with a letter, and contain only letters, numbers, hyphens, periods, underscores, and tildes."
  }
  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_members) : length(v.members) > 0])
    error_message = "The members set for any entry in pubsub_topic_members cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_members) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.pubsub_topic_members) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "service_account_bindings" {
  description = "A map of authoritative service account-level IAM bindings to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Authoritative bindings overwrite any existing members for the given role. An empty map can be provided to create no bindings. Be cautious not to manage the same role with both `service_account_bindings` and `service_account_members` for the same service account, as it can lead to state thrashing."
  type = map(object({
    service_account_id = string
    role               = string
    members            = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.service_account_bindings) : can(regex("^projects/.+/serviceAccounts/.+$", v.service_account_id))])
    error_message = "The service_account_id attribute must be the fully-qualified name of the service account (e.g., 'projects/{project}/serviceAccounts/{email}')."
  }
  validation {
    condition     = alltrue([for v in values(var.service_account_bindings) : length(v.members) > 0])
    error_message = "The members set for any binding in service_account_bindings cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.service_account_bindings) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.service_account_bindings) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "service_account_members" {
  description = "A map of non-authoritative service account-level IAM members to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Non-authoritative members will be added to a role without overwriting existing ones. An empty map can be provided to create no members. Be cautious not to manage the same role with both `service_account_bindings` and `service_account_members` for the same service account, as it can lead to state thrashing."
  type = map(object({
    service_account_id = string
    role               = string
    members            = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.service_account_members) : can(regex("^projects/.+/serviceAccounts/.+$", v.service_account_id))])
    error_message = "The service_account_id attribute must be the fully-qualified name of the service account (e.g., 'projects/{project}/serviceAccounts/{email}')."
  }
  validation {
    condition     = alltrue([for v in values(var.service_account_members) : length(v.members) > 0])
    error_message = "The members set for any entry in service_account_members cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.service_account_members) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.service_account_members) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "storage_bucket_bindings" {
  description = "A map of authoritative storage bucket-level IAM bindings to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Authoritative bindings overwrite any existing members for the given role. An empty map can be provided to create no bindings. Be cautious not to manage the same role with both `storage_bucket_bindings` and `storage_bucket_members` for the same bucket, as it can lead to state thrashing."
  type = map(object({
    bucket  = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.storage_bucket_bindings) : length(v.members) > 0])
    error_message = "The members set for any binding in storage_bucket_bindings cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.storage_bucket_bindings) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.storage_bucket_bindings) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}

variable "storage_bucket_members" {
  description = "A map of non-authoritative storage bucket-level IAM members to create. The key of the map is a logical name for the binding, and the value is an object with the binding details. Non-authoritative members will be added to a role without overwriting existing ones. An empty map can be provided to create no members. Be cautious not to manage the same role with both `storage_bucket_bindings` and `storage_bucket_members` for the same bucket, as it can lead to state thrashing."
  type = map(object({
    bucket  = string
    role    = string
    members = set(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for v in values(var.storage_bucket_members) : length(v.members) > 0])
    error_message = "The members set for any entry in storage_bucket_members cannot be empty."
  }
  validation {
    condition     = alltrue([for v in values(var.storage_bucket_members) : !can(regex("^(roles/)?(owner|editor|viewer)$", v.role))])
    error_message = "Using primitive roles (owner, editor, viewer) is not recommended. Please use a more granular role."
  }
  validation {
    condition     = alltrue([for v in values(var.storage_bucket_members) : alltrue([for m in v.members : !contains(["allUsers", "allAuthenticatedUsers"], m)])])
    error_message = "Granting roles to 'allUsers' or 'allAuthenticatedUsers' is not recommended. Please use a more specific member."
  }
}
