# This file defines the input variables for the IAM Access Bindings module.
variable "bindings" {
  # A map of IAM bindings to apply. The key is a unique logical name for the binding, and the value is an object containing the binding details.
  # The `type` attribute specifies the resource level (e.g., 'project', 'storage_bucket', 'service_account').
  # The `id` attribute is the identifier for that resource (e.g., project ID, bucket name, or service account email).
  # The `role` attribute is the IAM role to grant (e.g., 'roles/viewer').
  # The `members` attribute is a list of members to assign to the role (e.g., ['user:jane@example.com']).
  # Note: `google_*_iam_binding` resources are authoritative and will overwrite any existing members for the specified role.
  description = "A map of IAM bindings to apply, where each key is a unique name for the binding and the value is an object describing the binding's type, resource ID, role, and members."
  type = map(object({
    # The type of resource to apply the binding to. Must be one of 'project', 'storage_bucket', or 'service_account'.
    type = string
    # The identifier of the resource (project ID, bucket name, or service account email).
    id = string
    # The IAM role to be granted.
    role = string
    # A list of members to be granted the role.
    members = list(string)
  }))
  # By default, no bindings are created.
  default = {}

  validation {
    # Ensures that the 'type' attribute for each binding is one of the supported values.
    condition     = alltrue([for b in values(var.bindings) : contains(["project", "storage_bucket", "service_account"], b.type)])
    error_message = "The 'type' attribute for each binding must be one of: 'project', 'storage_bucket', 'service_account'."
  }
}
