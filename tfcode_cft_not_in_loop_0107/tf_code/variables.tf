variable "project_bindings" {
  description = "A map of project-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'project' (the project ID), 'role', and 'members' attributes. An optional 'condition' block can also be specified."
  type = map(object({
    project = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  }))
  default = {}
}

variable "folder_bindings" {
  description = "A map of folder-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'folder' (the folder ID in the format 'folders/123456'), 'role', and 'members' attributes. An optional 'condition' block can also be specified."
  type = map(object({
    folder  = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  }))
  default = {}
}

variable "organization_bindings" {
  description = "A map of organization-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'org_id' (the organization ID), 'role', and 'members' attributes. An optional 'condition' block can also be specified."
  type = map(object({
    org_id  = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  }))
  default = {}
}

variable "storage_bucket_bindings" {
  description = "A map of storage bucket-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'bucket' (the bucket name), 'role', and 'members' attributes. An optional 'condition' block can also be specified."
  type = map(object({
    bucket  = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  }))
  default = {}
}

variable "service_account_bindings" {
  description = "A map of service account-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'service_account_id' (the full name of the service account), 'role', and 'members' attributes. An optional 'condition' block can also be specified."
  type = map(object({
    service_account_id = string
    role               = string
    members            = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  }))
  default = {}
}
