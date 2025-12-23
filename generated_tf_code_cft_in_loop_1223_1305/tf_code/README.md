# Terraform Google Cloud IAM Module

This module manages non-authoritative IAM member bindings for various Google Cloud resources, including Projects, Service Accounts, and Storage Buckets.

It allows for granular control by adding individual members to specific roles without overwriting existing IAM policies. This approach is safer for managing permissions in environments where multiple teams or processes manage IAM. The module also supports conditional IAM bindings.

## Usage

The following example shows how to use the module to grant IAM roles at the project, service account, and storage bucket levels.

```hcl
module "iam_bindings" {
  source = "./" # Replace with the actual source path for the module

  project_bindings = {
    "my-gcp-project-id" = {
      "roles/viewer" = {
        members = [
          "user:jane.doe@example.com",
          "group:gcp-viewers@example.com",
        ]
      }
      "roles/storage.objectAdmin" = {
        members = [
          "serviceAccount:my-app-sa@my-gcp-project-id.iam.gserviceaccount.com"
        ]
        condition = {
          title       = "access_to_specific_prefix"
          expression  = "resource.name.startsWith(\"projects/_/buckets/my-bucket/objects/confidential/\")"
          description = "Allow access only to the confidential prefix."
        }
      }
    }
  }

  service_account_bindings = {
    "projects/my-gcp-project-id/serviceAccounts/another-sa@my-gcp-project-id.iam.gserviceaccount.com" = {
      "roles/iam.serviceAccountUser" = {
        members = [
          "user:john.smith@example.com",
        ]
      }
    }
  }

  storage_bucket_bindings = {
    "my-storage-bucket-name" = {
      "roles/storage.objectViewer" = {
        members = [
          "user:auditor@example.com",
        ]
      }
    }
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

The following requirements are needed by this module.

### Software

The following software versions are required:
- Terraform: `>= 1.0`
- Google Provider: `>= 4.51.0`

### APIs

The following APIs must be enabled on the target project:
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
- Identity and Access Management (IAM) API: `iam.googleapis.com`

### Permissions

The principal (user, group, or service account) running Terraform needs the following IAM roles:
- **Project Bindings**: `roles/resourcemanager.projectIamAdmin` on each project specified in `project_bindings`.
- **Service Account Bindings**: `roles/iam.serviceAccountAdmin` on each service account specified in `service_account_bindings`.
- **Storage Bucket Bindings**: `roles/storage.admin` on each bucket specified in `storage_bucket_bindings`.

## Inputs

The following input variables are supported:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| `project_bindings` | A map of project-level IAM bindings. The key is the project ID, and the value is a map of IAM roles to a list of members and an optional condition. | <pre>map(map(object({<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  })))</pre> | `{}` | no |
| `service_account_bindings` | A map of service account-level IAM bindings. The key is the full service account ID, and the value is a map of IAM roles to a list of members and an optional condition. | <pre>map(map(object({<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  })))</pre> | `{}` | no |
| `storage_bucket_bindings` | A map of storage bucket-level IAM bindings. The key is the bucket name, and the value is a map of IAM roles to a list of members and an optional condition. | <pre>map(map(object({<br>    members = list(string)<br>    condition = optional(object({<br>      title       = string<br>      expression  = string<br>      description = optional(string)<br>    }))<br>  })))</pre> | `{}` | no |

## Outputs

The following outputs are exported:

| Name | Description |
|------|-------------|
| `project_iam_members` | A map of the created `google_project_iam_member` resources. |
| `service_account_iam_members` | A map of the created `google_service_account_iam_member` resources. |
| `storage_bucket_iam_members` | A map of the created `google_storage_bucket_iam_member` resources. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
