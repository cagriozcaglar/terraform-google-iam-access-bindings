variable "project_bindings" {
  description = "A map of IAM bindings for projects. The key is a logical name for the binding. The value is an object with the project ID, role, a list of members, and an optional condition."
  type = map(object({
    project = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}
}

variable "folder_bindings" {
  description = "A map of IAM bindings for folders. The key is a logical name for the binding. The value is an object with the folder ID (e.g., 'folders/12345'), role, a list of members, and an optional condition."
  type = map(object({
    folder  = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}
}

variable "organization_bindings" {
  description = "A map of IAM bindings for an organization. The key is a logical name for the binding. The value is an object with the organization ID, role, a list of members, and an optional condition."
  type = map(object({
    org_id  = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}
}

variable "billing_account_bindings" {
  description = "A map of IAM bindings for a billing account. The key is a logical name for the binding. The value is an object with the billing account ID, role, a list of members, and an optional condition."
  type = map(object({
    billing_account_id = string
    role               = string
    members            = list(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}
}

variable "service_account_bindings" {
  description = "A map of IAM bindings for a service account. The key is a logical name for the binding. The value is an object with the service account ID (in the form 'projects/{project}/serviceAccounts/{email}'), role, a list of members, and an optional condition."
  type = map(object({
    service_account_id = string
    role               = string
    members            = list(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}
}

variable "storage_bucket_bindings" {
  description = "A map of IAM bindings for a storage bucket. The key is a logical name for the binding. The value is an object with the bucket name (without 'gs://'), role, a list of members, and an optional condition."
  type = map(object({
    bucket  = string
    role    = string
    members = list(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default = {}
}
