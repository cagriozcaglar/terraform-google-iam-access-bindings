# Google Cloud Authoritative IAM Bindings Module

This module manages authoritative IAM bindings for various Google Cloud resource types.

An IAM binding is **authoritative** for a given role, which means it will overwrite any existing members for that role on the resource. If you want to add a member to a role without affecting existing members (additive), you should use the `google_*_iam_member` resources instead.

This module supports creating bindings at the following levels:
- Project
- Folder
- Organization
- Billing Account
- Service Account
- Storage Bucket

## Compatibility

This module is meant for use with Terraform 1.3+.

## Usage

The following example shows how to create authoritative IAM bindings for a project and a storage bucket. This includes a simple role binding and a conditional role binding.

```hcl
module "iam_bindings" {
  source = "path/to/this/module"

  project_bindings = {
    "project-viewer-binding" = {
      project = "my-gcp-project-id"
      role    = "roles/viewer"
      members = [
        "user:jane.doe@example.com",
        "group:my-group@example.com",
      ]
    },
    "project-storage-admin-conditional" = {
      project = "my-gcp-project-id"
      role    = "roles/storage.admin"
      members = [
        "serviceAccount:my-sa@my-gcp-project-id.iam.gserviceaccount.com"
      ]
      condition = {
        title      = "limited-to-prefix"
        expression = "resource.name.startsWith(\"projects/_/buckets/my-specific-bucket/\")"
        description = "Limits access to a specific bucket prefix"
      }
    }
  }

  storage_bucket_bindings = {
    "bucket-reader-binding" = {
      bucket  = "my-storage-bucket-name"
      role    = "roles/storage.objectViewer"
      members = [
        "user:john.smith@example.com",
      ]
    }
  }

  organization_bindings = {
    "org-auditor-binding" = {
      org_id  = "123456789012"
      role    = "roles/logging.viewer"
      members = [
        "group:auditors@example.com",
      ]
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| billing\_account\_bindings | A map of IAM bindings for a billing account. The key is a logical name for the binding. The value is an object with the billing account ID, role, a list of members, and an optional condition. | <pre>map(object({<br>    billing_account_id = string<br>    role               = string<br>    members            = list(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| folder\_bindings | A map of IAM bindings for folders. The key is a logical name for the binding. The value is an object with the folder ID (e.g., 'folders/12345'), role, a list of members, and an optional condition. | <pre>map(object({<br>    folder  = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| organization\_bindings | A map of IAM bindings for an organization. The key is a logical name for the binding. The value is an object with the organization ID, role, a list of members, and an optional condition. | <pre>map(object({<br>    org_id  = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| project\_bindings | A map of IAM bindings for projects. The key is a logical name for the binding. The value is an object with the project ID, role, a list of members, and an optional condition. | <pre>map(object({<br>    project = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| service\_account\_bindings | A map of IAM bindings for a service account. The key is a logical name for the binding. The value is an object with the service account ID (in the form 'projects/{project}/serviceAccounts/{email}'), role, a list of members, and an optional condition. | <pre>map(object({<br>    service_account_id = string<br>    role               = string<br>    members            = list(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| storage\_bucket\_bindings | A map of IAM bindings for a storage bucket. The key is a logical name for the binding. The value is an object with the bucket name (without 'gs://'), role, a list of members, and an optional condition. | <pre>map(object({<br>    bucket  = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| billing\_account\_bindings\_ids | A map of the full resource IDs for the created billing account IAM bindings. The keys are the logical names of the bindings. |
| folder\_bindings\_ids | A map of the full resource IDs for the created folder IAM bindings. The keys are the logical names of the bindings. |
| organization\_bindings\_ids | A map of the full resource IDs for the created organization IAM bindings. The keys are the logical names of the bindings. |
| project\_bindings\_ids | A map of the full resource IDs for the created project IAM bindings. The keys are the logical names of the bindings. |
| service\_account\_bindings\_ids | A map of the full resource IDs for the created service account IAM bindings. The keys are the logical names of the bindings. |
| storage\_bucket\_bindings\_ids | A map of the full resource IDs for the created storage bucket IAM bindings. The keys are the logical names of the bindings. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

These sections describe requirements for using this module.

### Software

The following software is required:
- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0

### Providers

The following providers are required:

| Name | Version |
|------|---------|
| google | >= 4.63.0, < 6.0.0 |

### APIs

The necessary APIs for the target resources must be enabled on the appropriate project. For example:
- **Cloud Resource Manager API:** `cloudresourcemanager.googleapis.com`
- **Cloud Billing API:** `cloudbilling.googleapis.com`
- **Identity and Access Management (IAM) API:** `iam.googleapis.com`
- **Cloud Storage API:** `storage.googleapis.com`
