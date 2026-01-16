# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

variable "bindings" {
  description = <<-EOD
    A map of IAM bindings to be created, with the map key being a logical name for the binding.

    Each binding object in the map supports the following attributes:
    - `role`: (Required) The role to be assigned (e.g., 'roles/storage.objectViewer').
    - `members`: (Required) A set of members to be granted the role. See the official documentation for valid member formats: https://cloud.google.com/iam/docs/overview#iam-principals
    - `project`: (Optional) The ID of the project to apply the binding to.
    - `folder`: (Optional) The ID of the folder to apply the binding to. Must be in the format 'folders/1234567890'.
    - `organization`: (Optional) The numeric ID of the organization to apply the binding to.
    - `bucket`: (Optional) The name of the Cloud Storage bucket to apply the binding to.
    - `condition`: (Optional) An object that specifies a conditional IAM binding.
      - `title`: (Required) The title of the condition.
      - `expression`: (Required) The Common Expression Language (CEL) expression of the condition.
      - `description`: (Optional) An optional description of the condition.

    Note: For each binding object, exactly one of `project`, `folder`, `organization`, or `bucket` must be specified.
  EOD
  type = map(object({
    role    = string
    members = set(string)
    project = optional(string)
    folder  = optional(string)
    organization = optional(string)
    bucket = optional(string)
    condition = optional(object({
      title       = string
      description = optional(string)
      expression  = string
    }))
  }))
  default     = {}
  validation {
    condition = alltrue([
      for b in values(var.bindings) : (
        (b.project != null ? 1 : 0) +
        (b.folder != null ? 1 : 0) +
        (b.organization != null ? 1 : 0) +
        (b.bucket != null ? 1 : 0)
      ) == 1
    ])
    error_message = "Each binding must specify exactly one of 'project', 'folder', 'organization', or 'bucket'."
  }
}
