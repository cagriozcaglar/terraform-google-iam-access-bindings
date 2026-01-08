output "project_bindings" {
  description = "A map of the created project IAM binding resources, keyed by the logical names provided in the input."
  value       = google_project_iam_binding.project
}

output "folder_bindings" {
  description = "A map of the created folder IAM binding resources, keyed by the logical names provided in the input."
  value       = google_folder_iam_binding.folder
}

output "organization_bindings" {
  description = "A map of the created organization IAM binding resources, keyed by the logical names provided in the input."
  value       = google_organization_iam_binding.organization
}

output "storage_bucket_bindings" {
  description = "A map of the created storage bucket IAM binding resources, keyed by the logical names provided in the input."
  value       = google_storage_bucket_iam_binding.storage_bucket
}

output "service_account_bindings" {
  description = "A map of the created service account IAM binding resources, keyed by the logical names provided in the input."
  value       = google_service_account_iam_binding.service_account
}
