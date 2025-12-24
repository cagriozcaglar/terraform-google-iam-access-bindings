# The outputs.tf file is used to define the output values of the module.
# Outputs are a way to expose information about the resources created by the module to the user.
# They can be used to link modules together or to provide information to the user in the CLI output.

output "id" {
  description = "The fully-qualified ID of the created IAM binding. The format varies depending on the resource type. Returns null if no binding is created."
  value = one(compact(concat(
    google_project_iam_binding.project_binding.*.id,
    google_storage_bucket_iam_binding.bucket_binding.*.id,
    google_service_account_iam_binding.sa_binding.*.id
  )))
}

output "etag" {
  description = "The etag of the created IAM binding. This is used for optimistic concurrency control. Returns null if no binding is created."
  value = one(compact(concat(
    google_project_iam_binding.project_binding.*.etag,
    google_storage_bucket_iam_binding.bucket_binding.*.etag,
    google_service_account_iam_binding.sa_binding.*.etag
  )))
}
