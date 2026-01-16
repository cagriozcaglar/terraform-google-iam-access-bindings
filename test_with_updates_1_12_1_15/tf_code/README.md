# Google Cloud IAM Bindings Module

This module simplifies the management of Google Cloud IAM bindings across different resource types from a single, declarative map. It allows you to define IAM role bindings for projects, folders, organizations, and Cloud Storage buckets in a unified way.

This module is designed to be authoritative for a given role on a resource. It uses `*_iam_binding` resources, which will overwrite any existing members for that role. If you need to add members to a role without affecting existing members, consider using `*_iam_member` resources instead.

## Usage

Below are examples of how to use the module to apply IAM bindings to different resource types.

### Basic Usage

This example applies a single role to a project, a folder, an organization, and a Cloud Storage bucket.

```hcl
module "iam_bindings" {
  source = "./" # Or a path to the module

  bindings = {
    # Grant BigQuery Data Viewer role at the project level
    "project-data-viewers" = {
      project = "my-gcp-project-id"
      role    = "roles/bigquery.dataViewer"
      members = [
        "group:data-analysts@example.com",
      ]
    },
    
    # Grant Logging Viewer role at the folder level
    "folder-log-viewers" = {
      folder  = "folders/1234567890"
      role    = "roles/logging.viewer"
      members = [
        "serviceAccount:auditor-sa@my-gcp-project-id.iam.gserviceaccount.com",
      ]
    },

    # Grant Billing Admin role at the organization level
    "org-billing-admins" = {
      organization = "9876543210"
      role         = "roles/billing.admin"
      members = [
        "user:finance-admin@example.com",
      ]
    },
    
    # Grant Storage Object Admin role at the bucket level
    "bucket-storage-admins" = {
      bucket  = "my-important-storage-bucket"
      role    = "roles/storage.objectAdmin"
      members = [
        "user:storage-manager@example.com",
      ]
    }
  }
}
```

### Conditional IAM Binding

This example demonstrates how to create a conditional IAM binding, which grants a role only when specific conditions are met.

```hcl
module "iam_bindings_conditional" {
  source = "./" # Or a path to the module

  bindings = {
    "org-project-creator-conditional" = {
      organization = "9876543210"
      role         = "roles/resourcemanager.projectCreator"
      members = [
        "group:developers@example.com",
      ]
      condition = {
        title       = "limit_to_dev_folder"
        description = "Allow project creation only within the development folder"
        expression  = "resource.parent == 'folders/1234567890'"
      }
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bindings"></a> [bindings](#input\_bindings) | A map of IAM bindings to be created, with the map key being a logical name for the binding.<br><br>Each binding object in the map supports the following attributes:<br>- `role`: (Required) The role to be assigned (e.g., 'roles/storage.objectViewer').<br>- `members`: (Required) A set of members to be granted the role. See the official documentation for valid member formats: https://cloud.google.com/iam/docs/overview#iam-principals<br>- `project`: (Optional) The ID of the project to apply the binding to.<br>- `folder`: (Optional) The ID of the folder to apply the binding to. Must be in the format 'folders/1234567890'.<br>- `organization`: (Optional) The numeric ID of the organization to apply the binding to.<br>- `bucket`: (Optional) The name of the Cloud Storage bucket to apply the binding to.<br>- `condition`: (Optional) An object that specifies a conditional IAM binding.<br>  - `title`: (Required) The title of the condition.<br>  - `expression`: (Required) The Common Expression Language (CEL) expression of the condition.<br>  - `description`: (Optional) An optional description of the condition.<br><br>Note: For each binding object, exactly one of `project`, `folder`, `organization`, or `bucket` must be specified. | <pre>map(object({<br>    role    = string<br>    members = set(string)<br>    project = optional(string)<br>    folder  = optional(string)<br>    organization = optional(string)<br>    bucket = optional(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_all_bindings"></a> [all\_bindings](#output\_all\_bindings) | A structured map containing all created IAM binding resources, categorized by their resource type (project, folder, organization, bucket). |
| <a name="output_bucket_bindings"></a> [bucket\_bindings](#output\_bucket\_bindings) | A map of the created `google_storage_bucket_iam_binding` resources, keyed by the logical names from the input `bindings` variable. |
| <a name="output_folder_bindings"></a> [folder\_bindings](#output\_folder\_bindings) | A map of the created `google_folder_iam_binding` resources, keyed by the logical names from the input `bindings` variable. |
| <a name="output_organization_bindings"></a> [organization\_bindings](#output\_organization\_bindings) | A map of the created `google_organization_iam_binding` resources, keyed by the logical names from the input `bindings` variable. |
| <a name="output_project_bindings"></a> [project\_bindings](#output\_project\_bindings) | A map of the created `google_project_iam_binding` resources, keyed by the logical names from the input `bindings` variable. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

### Software

The following software is required to use this module:

- [Terraform](https://www.terraform.io/downloads.html): >= 1.3

### Providers

The following providers are required:

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | ~> 5.14 |
