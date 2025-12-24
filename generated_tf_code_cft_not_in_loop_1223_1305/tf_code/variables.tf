# The variables.tf file is used to define the input variables for the module.
# Each variable is defined with a type, a description, and an optional default value.
# This makes the module's interface clear and easy to understand.
variable "role" {
  description = "The role that should be applied. For a list of roles, see https://cloud.google.com/iam/docs/understanding-roles."
  type        = string
  default     = null
}

variable "members" {
  description = "A list of users, service accounts, or groups who will be granted the specified role. For a list of supported member types, see https://cloud.google.com/iam/docs/overview#iam_members."
  type        = list(string)
  default     = []
}

variable "project" {
  description = "The ID of the project to which the role should be bound. Conflicts with `bucket` and `service_account_id`."
  type        = string
  default     = null
}

variable "bucket" {
  description = "The name of the GCS bucket to which the role should be bound. Conflicts with `project` and `service_account_id`."
  type        = string
  default     = null
}

variable "service_account_id" {
  description = "The fully-qualified ID of the service account to which the role should be bound. Conflicts with `project` and `bucket`. Example: `projects/my-project/serviceAccounts/my-sa@my-project.iam.gserviceaccount.com`."
  type        = string
  default     = null
}

variable "condition" {
  description = "An IAM condition block to apply to the binding. See https://cloud.google.com/iam/docs/conditions-overview for more information."
  type = object({
    title       = string
    expression  = string
    description = optional(string)
  })
  default = null
}
