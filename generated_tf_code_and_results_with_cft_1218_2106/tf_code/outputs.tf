output "project_bindings_ids" {
  description = "A map of the full resource IDs for the created project IAM bindings. The keys are the logical names of the bindings."
  value       = { for k, v in google_project_iam_binding.project_bindings : k => v.id }
}

output "folder_bindings_ids" {
  description = "A map of the full resource IDs for the created folder IAM bindings. The keys are the logical names of the bindings."
  value       = { for k, v in google_folder_iam_binding.folder_bindings : k => v.id }
}

output "organization_bindings_ids" {
  description = "A map of the full resource IDs for the created organization IAM bindings. The keys are the logical names of the bindings."
  value       = { for k, v in google_organization_iam_binding.organization_bindings : k => v.id }
}

output "billing_account_bindings_ids" {
  description = "A map of the full resource IDs for the created billing account IAM bindings. The keys are the logical names of the bindings."
  value       = { for k, v in google_billing_account_iam_binding.billing_account_bindings : k => v.id }
}

output "service_account_bindings_ids" {
  description = "A map of the full resource IDs for the created service account IAM bindings. The keys are the logical names of the bindings."
  value       = { for k, v in google_service_account_iam_binding.service_account_bindings : k => v.id }
}

output "storage_bucket_bindings_ids" {
  description = "A map of the full resource IDs for the created storage bucket IAM bindings. The keys are the logical names of the bindings."
  value       = { for k, v in google_storage_bucket_iam_binding.storage_bucket_bindings : k => v.id }
}
