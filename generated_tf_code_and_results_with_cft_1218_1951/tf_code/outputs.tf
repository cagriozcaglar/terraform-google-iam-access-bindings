# This file defines the outputs of the IAM Access Bindings module.
output "project_bindings" {
  # Provides access to the full resource objects for all created project-level IAM bindings.
  # The output is a map where keys correspond to the keys provided in the input `bindings` variable.
  # Each value contains all attributes of the `google_project_iam_binding` resource, such as `project`, `role`, and `etag`.
  description = "A map of the created project-level IAM bindings, keyed by the binding name from the input variable."
  value       = google_project_iam_binding.project_binding
}

output "storage_bucket_bindings" {
  # Provides access to the full resource objects for all created storage bucket IAM bindings.
  # The output is a map where keys correspond to the keys provided in the input `bindings` variable.
  # Each value contains all attributes of the `google_storage_bucket_iam_binding` resource, such as `bucket`, `role`, and `etag`.
  description = "A map of the created storage bucket-level IAM bindings, keyed by the binding name from the input variable."
  value       = google_storage_bucket_iam_binding.storage_bucket_binding
}

output "service_account_bindings" {
  # Provides access to the full resource objects for all created service account IAM bindings.
  # The output is a map where keys correspond to the keys provided in the input `bindings` variable.
  # Each value contains all attributes of the `google_service_account_iam_binding` resource, such as `service_account_id`, `role`, and `etag`.
  description = "A map of the created service account-level IAM bindings, keyed by the binding name from the input variable."
  value       = google_service_account_iam_binding.service_account_binding
}
