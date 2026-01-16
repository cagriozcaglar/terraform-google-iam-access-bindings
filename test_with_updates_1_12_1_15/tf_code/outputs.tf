# <!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# <!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

output "project_bindings" {
  description = "A map of the created `google_project_iam_binding` resources, keyed by the logical names from the input `bindings` variable."
  value       = google_project_iam_binding.project
}

output "folder_bindings" {
  description = "A map of the created `google_folder_iam_binding` resources, keyed by the logical names from the input `bindings` variable."
  value       = google_folder_iam_binding.folder
}

output "organization_bindings" {
  description = "A map of the created `google_organization_iam_binding` resources, keyed by the logical names from the input `bindings` variable."
  value       = google_organization_iam_binding.organization
}

output "bucket_bindings" {
  description = "A map of the created `google_storage_bucket_iam_binding` resources, keyed by the logical names from the input `bindings` variable."
  value       = google_storage_bucket_iam_binding.bucket
}

output "all_bindings" {
  description = "A structured map containing all created IAM binding resources, categorized by their resource type (project, folder, organization, bucket)."
  value = {
    project      = google_project_iam_binding.project
    folder       = google_folder_iam_binding.folder
    organization = google_organization_iam_binding.organization
    bucket       = google_storage_bucket_iam_binding.bucket
  }
}
