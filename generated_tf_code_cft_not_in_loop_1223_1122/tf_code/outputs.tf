# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# This file is automatically populated by terraform-docs
# To update, run `terraform-docs .`
# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
output "bindings" {
  description = "A map of the created IAM member bindings, keyed by the logical name provided in the input `bindings` variable. Each value contains the resource identifier, role, members, and the etag of the resource's IAM policy."
  value = { for k, v in var.bindings : k => {
    resource_type = v.resource_type
    resource_id   = v.resource_id
    role          = v.role
    members       = v.members
    # The etag is the etag of the parent resource's IAM policy.
    # All members in a single binding will have the same etag after an apply.
    # We take the first one from the list of etags for this binding key.
    etag = try(local.all_etags[k][0], null)
    }
  }
}
