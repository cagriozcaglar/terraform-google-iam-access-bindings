output "project_id" {
  description = "The ID of the created Google Cloud project."
  value       = google_project.project.project_id
}

output "folder_name" {
  description = "The name of the created folder (e.g., 'folders/12345')."
  value       = google_folder.folder.name
}

output "bucket_name" {
  description = "The name of the created Cloud Storage bucket."
  value       = google_storage_bucket.bucket.name
}

output "service_account_email" {
  description = "The email of the created service account."
  value       = google_service_account.test_sa.email
}

output "project_bindings" {
  description = "A map of the created `google_project_iam_binding` resources."
  value       = module.iam_bindings.project_bindings
}

output "folder_bindings" {
  description = "A map of the created `google_folder_iam_binding` resources."
  value       = module.iam_bindings.folder_bindings
}

output "organization_bindings" {
  description = "A map of the created `google_organization_iam_binding` resources."
  value       = module.iam_bindings.organization_bindings
}

output "bucket_bindings" {
  description = "A map of the created `google_storage_bucket_iam_binding` resources."
  value       = module.iam_bindings.bucket_bindings
}

output "all_bindings" {
  description = "A structured map containing all created IAM binding resources."
  value       = module.iam_bindings.all_bindings
}
