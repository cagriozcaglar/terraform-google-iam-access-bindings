variable "project_bindings" {
  description = "A map of project-level IAM bindings. The key is the project ID, and the value is a map of IAM roles to a list of members and an optional condition."
  type = map(map(object({
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  })))
  default = {}
}

variable "service_account_bindings" {
  description = "A map of service account-level IAM bindings. The key is the full service account ID, and the value is a map of IAM roles to a list of members and an optional condition."
  type = map(map(object({
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  })))
  default = {}
}

variable "storage_bucket_bindings" {
  description = "A map of storage bucket-level IAM bindings. The key is the bucket name, and the value is a map of IAM roles to a list of members and an optional condition."
  type = map(map(object({
    members = list(string)
    condition = optional(object({
      title       = string
      expression  = string
      description = optional(string)
    }))
  })))
  default = {}
}
