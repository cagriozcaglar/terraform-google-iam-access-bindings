# Terraform GCP IAM Bindings Module

This Terraform module simplifies the management of Google Cloud IAM policies by providing a centralized way to create authoritative IAM bindings (`*_iam_binding`) for a given role across different resource levels. It supports creating bindings for Projects, Folders, Organizations, Storage Buckets, and Service Accounts.

This module is designed to be flexible, allowing you to define multiple bindings for various resources in a single module call. It also supports conditional IAM bindings to grant permissions that are only effective when specified conditions are met.

## Usage

Below is a comprehensive example of how to use this module to apply IAM bindings at different resource levels, including a conditional binding.

```hcl
module "iam_bindings" {
  source = "./path/to/module" # Replace with the actual source path

  project_bindings = {
    "project-viewer-binding" = {
      project = "my-gcp-project-id"
      role    = "roles/viewer"
      members = [
        "user:jane.doe@example.com",
        "group:gcp-viewers@example.com",
      ]
    },
    "conditional-storage-admin" = {
      project = "my-gcp-project-id"
      role    = "roles/storage.admin"
      members = [
        "serviceAccount:my-app@my-gcp-project-id.iam.gserviceaccount.com",
      ]
      condition = {
        title       = "expires_end_of_2024"
        expression  = "request.time < timestamp(\"2025-01-01T00:00:00Z\")"
        description = "This binding is only valid until the end of 2024."
      }
    }
  }

  folder_bindings = {
    "folder-browser-binding" = {
      folder  = "folders/123456789012"
      role    = "roles/browser"
      members = [
        "domain:example.com",
      ]
    }
  }

  organization_bindings = {
    "org-billing-user" = {
      org_id  = "112233445566"
      role    = "roles/billing.user"
      members = [
        "group:finance-team@example.com",
      ]
    }
  }

  storage_bucket_bindings = {
    "bucket-object-creator" = {
      bucket  = "my-important-data-bucket"
      role    = "roles/storage.objectCreator"
      members = [
        "serviceAccount:data-writer@my-gcp-project-id.iam.gserviceaccount.com",
      ]
    }
  }

  service_account_bindings = {
    "sa-token-creator" = {
      service_account_id = "projects/my-gcp-project-id/serviceAccounts/my-app@my-gcp-project-id.iam.gserviceaccount.com"
      role               = "roles/iam.serviceAccountTokenCreator"
      members = [
        "serviceAccount:another-sa@my-gcp-project-id.iam.gserviceaccount.com",
      ]
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | ~> 5.14 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_folder_bindings"></a> [folder\_bindings](#input\_folder\_bindings) | A map of folder-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'folder' (the folder ID in the format 'folders/123456'), 'role', and 'members' attributes. An optional 'condition' block can also be specified. | <pre>map(object({<br>    folder  = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_organization_bindings"></a> [organization\_bindings](#input\_organization\_bindings) | A map of organization-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'org\_id' (the organization ID), 'role', and 'members' attributes. An optional 'condition' block can also be specified. | <pre>map(object({<br>    org_id  = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_project_bindings"></a> [project\_bindings](#input\_project\_bindings) | A map of project-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'project' (the project ID), 'role', and 'members' attributes. An optional 'condition' block can also be specified. | <pre>map(object({<br>    project = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_service_account_bindings"></a> [service\_account\_bindings](#input\_service\_account\_bindings) | A map of service account-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'service\_account\_id' (the full name of the service account), 'role', and 'members' attributes. An optional 'condition' block can also be specified. | <pre>map(object({<br>    service_account_id = string<br>    role               = string<br>    members            = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_storage_bucket_bindings"></a> [storage\_bucket\_bindings](#input\_storage\_bucket\_bindings) | A map of storage bucket-level IAM bindings. The key of each entry is a logical name for the binding. The value is an object with 'bucket' (the bucket name), 'role', and 'members' attributes. An optional 'condition' block can also be specified. | <pre>map(object({<br>    bucket  = string<br>    role    = string<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_folder_bindings"></a> [folder\_bindings](#output\_folder\_bindings) | A map of the created folder IAM binding resources, keyed by the logical names provided in the input. |
| <a name="output_organization_bindings"></a> [organization\_bindings](#output\_organization\_bindings) | A map of the created organization IAM binding resources, keyed by the logical names provided in the input. |
| <a name="output_project_bindings"></a> [project\_bindings](#output\_project\_bindings) | A map of the created project IAM binding resources, keyed by the logical names provided in the input. |
| <a name="output_service_account_bindings"></a> [service\_account\_bindings](#output\_service\_account\_bindings) | A map of the created service account IAM binding resources, keyed by the logical names provided in the input. |
| <a name="output_storage_bucket_bindings"></a> [storage\_bucket\_bindings](#output\_storage\_bucket\_bindings) | A map of the created storage bucket IAM binding resources, keyed by the logical names provided in the input. |

## Resources

| Name | Type |
|------|------|
| [google_folder_iam_binding.folder](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/folder_iam_binding) | resource |
| [google_organization_iam_binding.organization](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/organization_iam_binding) | resource |
| [google_project_iam_binding.project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_binding) | resource |
| [google_service_account_iam_binding.service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_iam_binding) | resource |
| [google_storage_bucket_iam_binding.storage_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam_binding) | resource |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
