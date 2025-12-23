# This file is automatically populated by terraform-docs
# To update, run `terraform-docs .`
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
variable "bindings" {
  description = <<-EOT
  A map of IAM bindings to create. The key of the map is a logical name for the binding, used as a part of the `for_each` key in the underlying resources.
  The value is an object with the following attributes:
  - `resource_type`: (Required|String) The type of resource to apply the binding to. Supported values are: `project`, `storage_bucket`, `pubsub_topic`.
  - `resource_id`: (Required|String) The identifier of the resource.
    - For `project`: The project ID.
    - For `storage_bucket`: The bucket name.
    - For `pubsub_topic`: The full topic name in the format `projects/{project}/topics/{topic}`.
  - `role`: (Required|String) The IAM role to assign (e.g., `roles/storage.objectViewer`).
  - `members`: (Required|List of Strings) A list of members to grant the role to. See the [IAM Overview](https://cloud.google.com/iam/docs/overview#iam-principals) for a list of valid member types.
  - `condition`: (Optional|Object) An IAM condition block. See the [IAM Conditions documentation](https://cloud.google.com/iam/docs/conditions-overview) for details. It contains the following attributes:
    - `title`: (Required|String) A title for the condition.
    - `description`: (Optional|String) A description for the condition.
    - `expression`: (Required|String) The Common Expression Language (CEL) expression.
  EOT
  type = map(object({
    # The type of resource to apply the binding to.
    resource_type = string
    # The identifier of the resource.
    resource_id = string
    # The IAM role to assign.
    role = string
    # A list of members to grant the role to.
    members = list(string)
    # An IAM condition block.
    condition = optional(object({
      # A title for the condition.
      title = string
      # An optional description for the condition.
      description = optional(string)
      # The Common Expression Language (CEL) expression.
      expression = string
    }))
  }))
  # The default value is an empty map, meaning no bindings will be created.
  default = {}
}
