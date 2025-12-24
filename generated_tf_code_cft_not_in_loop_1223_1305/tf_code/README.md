# Terraform GCP IAM Binding Module

This module creates a single, authoritative IAM binding for a specified role on a Google Cloud resource. It is designed to be flexible, allowing you to bind a role to a GCP Project, a Google Cloud Storage Bucket, or a Service Account. This module uses `iam_binding` resources, which manage a role's entire roster of members for a resource.

**Note:** This module manages a single `*_iam_binding`. This is an authoritative resource. Any members not specified in the `members` variable for the given role will be removed from the binding. For non-authoritative management (adding a member to a role without affecting other members), consider using a module that manages `*_iam_member` resources instead.

## Usage

Below are examples of how to use this module to create IAM bindings for different resource types.

### Project IAM Binding

This example grants the `roles/viewer` role to a user and a group at the project level.

```hcl
module "project_iam_binding" {
  source  = "./path/to/module"

  project = "my-gcp-project-id"
  role    = "roles/viewer"
  members = [
    "user:jane.doe@example.com",
    "group:gcp-admins@example.com",
  ]
}
```

### Storage Bucket IAM Binding with a Condition

This example grants the `roles/storage.objectViewer` role to a service account on a specific GCS bucket, but only during weekdays.

```hcl
module "bucket_iam_binding_conditional" {
  source  = "./path/to/module"

  bucket  = "my-storage-bucket-name"
  role    = "roles/storage.objectViewer"
  members = [
    "serviceAccount:my-sa@my-gcp-project-id.iam.gserviceaccount.com",
  ]

  condition = {
    title       = "Access during business hours"
    expression  = "request.time.getDayOfWeek('America/New_York') >= 1 && request.time.getDayOfWeek('America/New_York') <= 5"
    description = "Allow access only on weekdays in New York time."
  }
}
```

### Service Account IAM Binding

This example grants a user the `roles/iam.serviceAccountUser` role, allowing them to impersonate the service account.

```hcl
module "sa_iam_binding" {
  source  = "./path/to/module"

  service_account_id = "projects/my-project/serviceAccounts/my-sa@my-project.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountUser"
  members = [
    "user:john.smith@example.com",
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket | The name of the GCS bucket to which the role should be bound. Conflicts with `project` and `service_account_id`. | `string` | `null` | no |
| condition | An IAM condition block to apply to the binding. See https://cloud.google.com/iam/docs/conditions-overview for more information. | `object({ title = string, expression = string, description = optional(string) })` | `null` | no |
| members | A list of users, service accounts, or groups who will be granted the specified role. For a list of supported member types, see https://cloud.google.com/iam/docs/overview#iam_members. | `list(string)` | `[]` | yes |
| project | The ID of the project to which the role should be bound. Conflicts with `bucket` and `service_account_id`. | `string` | `null` | no |
| role | The role that should be applied. For a list of roles, see https://cloud.google.com/iam/docs/understanding-roles. | `string` | `null` | yes |
| service\_account\_id | The fully-qualified ID of the service account to which the role should be bound. Conflicts with `project` and `bucket`. Example: `projects/my-project/serviceAccounts/my-sa@my-project.iam.gserviceaccount.com`. | `string` | `null` | no |

**Note:** Exactly one of `project`, `bucket`, or `service_account_id` must be specified for a resource to be created.

## Outputs

| Name | Description |
|------|-------------|
| etag | The etag of the created IAM binding. This is used for optimistic concurrency control. Returns `null` if no binding is created. |
| id | The fully-qualified ID of the created IAM binding. The format varies depending on the resource type. Returns `null` if no binding is created. |

## Requirements

The following requirements are needed by this module.

### Software

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Terraform Provider for GCP](https://github.com/hashicorp/terraform-provider-google) ~> 5.0

### Service Account

A service account with the following roles (or equivalent permissions) must be used to provision the resources of this module:

- **Project Binding:** `roles/resourcemanager.projectIamAdmin` on the target project.
- **Bucket Binding:** `roles/storage.admin` on the project, or a custom role with `storage.buckets.setIamPolicy` on the target bucket.
- **Service Account Binding:** `roles/iam.serviceAccountAdmin` on the target service account.

### APIs

A project with the following APIs enabled must be used to host the resources of this module:

- Identity and Access Management (IAM) API: `iam.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com` (if managing project bindings)
- Cloud Storage API: `storage.googleapis.com` (if managing bucket bindings)
