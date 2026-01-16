# This file provisions the resources needed to demonstrate the IAM bindings module.
# It creates a new project, folder, service account, and storage bucket,
# then uses the module to apply various IAM bindings to them.

# Provides a random suffix for resource names to ensure uniqueness.
resource "random_id" "suffix" {
  byte_length = 4
}

# Creates a new Google Cloud project for the example.
resource "google_project" "project" {
  project_id      = "${var.project_id_prefix}-${random_id.suffix.hex}"
  name            = "${var.project_id_prefix}-${random_id.suffix.hex}"
  org_id          = var.org_id
  billing_account = var.billing_account

  # Labels are used for organization and filtering.
  labels = {
    "terraform-example" = "iam-bindings"
  }
}

# Enables necessary APIs on the newly created project.
resource "google_project_service" "apis" {
  project                    = google_project.project.project_id
  service                    = "storage.googleapis.com"
  disable_dependent_services = true
}

# Creates a new folder within the specified organization.
resource "google_folder" "folder" {
  display_name = "iam-bindings-example-folder-${random_id.suffix.hex}"
  parent       = "organizations/${var.org_id}"
}

# Creates a new service account within the project.
resource "google_service_account" "test_sa" {
  project      = google_project.project.project_id
  account_id   = "iam-bindings-example-sa"
  display_name = "IAM Bindings Example SA"
}

# Creates a new Cloud Storage bucket within the project.
resource "google_storage_bucket" "bucket" {
  project      = google_project.project.project_id
  name         = "${var.project_id_prefix}-bucket-${random_id.suffix.hex}"
  location     = var.location
  force_destroy = true # Allows the bucket to be destroyed even if it contains objects.

  # Wait for the storage API to be enabled before creating the bucket.
  depends_on = [google_project_service.apis]
}

# Instantiate the IAM bindings module to apply roles to the created resources.
module "iam_bindings" {
  source = "../../"

  bindings = {
    # 1. Project-level binding: Grant a user the Project Viewer role.
    "project-viewer" = {
      project = google_project.project.project_id
      role    = "roles/viewer"
      members = [
        "user:example-user@google.com",
      ]
    },

    # 2. Folder-level binding: Grant a group the Folder Editor role.
    "folder-editor" = {
      folder  = google_folder.folder.name # e.g., "folders/1234567890"
      role    = "roles/resourcemanager.folderEditor"
      members = [
        "group:example-group@google.com",
      ]
    },

    # 3. Organization-level binding: Grant a different group the Browser role.
    "org-browser" = {
      organization = var.org_id
      role         = "roles/browser"
      members = [
        "group:auditors@google.com",
      ]
    },

    # 4. Bucket-level binding: Grant the service account Storage Object Viewer role.
    "bucket-object-viewer" = {
      bucket  = google_storage_bucket.bucket.name
      role    = "roles/storage.objectViewer"
      members = [
        "serviceAccount:${google_service_account.test_sa.email}",
      ]
    },

    # 5. Conditional binding: Grant a user the Project Owner role only until 2030.
    "project-conditional-owner" = {
      project = google_project.project.project_id
      role    = "roles/owner"
      members = [
        "user:temp-admin@google.com"
      ]
      condition = {
        title       = "expires_in_2030"
        description = "This binding is valid until the start of 2030."
        expression  = "request.time < timestamp(\"2030-01-01T00:00:00Z\")"
      }
    }
  }
}
