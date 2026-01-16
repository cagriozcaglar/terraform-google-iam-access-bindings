variable "org_id" {
  description = "The organization ID where the project and folder will be created."
  type        = string
}

variable "billing_account" {
  description = "The billing account ID to associate with the new project."
  type        = string
}

variable "project_id_prefix" {
  description = "A prefix for the created project ID and bucket name."
  type        = string
  default     = "tf-iam-example"
}

variable "location" {
  description = "The location for the Cloud Storage bucket."
  type        = string
  default     = "US-CENTRAL1"
}
