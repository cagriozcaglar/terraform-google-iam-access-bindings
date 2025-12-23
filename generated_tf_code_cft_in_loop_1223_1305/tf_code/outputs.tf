output "project_iam_members" {
  description = "A map of the created `google_project_iam_member` resources."
  value       = google_project_iam_member.project
}

output "service_account_iam_members" {
  description = "A map of the created `google_service_account_iam_member` resources."
  value       = google_service_account_iam_member.service_account
}

output "storage_bucket_iam_members" {
  description = "A map of the created `google_storage_bucket_iam_member` resources."
  value       = google_storage_bucket_iam_member.storage_bucket
}
