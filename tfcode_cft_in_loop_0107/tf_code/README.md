# Google Cloud IAM Module

This Terraform module simplifies the management of authoritative and non-authoritative IAM policies for a wide range of Google Cloud resources. It provides a centralized and declarative way to manage permissions for:

*   Organizations
*   Folders
*   Projects
*   Service Accounts
*   Storage Buckets
*   Pub/Sub Topics

The module supports two distinct modes for managing IAM policies, catering to different use cases:

*   **Authoritative (`*_bindings`):** This mode uses `google_*_iam_binding` resources. It creates an exclusive binding for a given role, replacing any existing members with the members specified in your configuration. This is ideal for enforcing strict, fully-managed permissions where you want Terraform to be the single source of truth.

*   **Non-authoritative (`*_members`):** This mode uses `google_*_iam_member` resources. It adds individual members to a role without affecting other members who might already have that role. This is useful for granting additive permissions without disrupting existing access configurations.

**Note:** Be cautious not to manage the same role on the same resource with both authoritative `_bindings` and non-authoritative `_members` variables, as this will cause a perpetual diff and state thrashing.

## Usage

Below is a basic example of how to use this module to manage IAM policies for a project and a storage bucket.

```hcl
module "iam_management" {
  source = "./path/to/module"

  project_bindings = {
    // Authoritatively sets the project viewers
    "project_viewers" = {
      project = "my-gcp-project-id"
      role    = "roles/viewer"
      members = [
        "group:gcp-viewers@example.com",
      ]
    }
  }

  project_members = {
    // Additively grants Storage Admin role to specific identities
    "project_storage_admins" = {
      project = "my-gcp-project-id"
      role    = "roles/storage.admin"
      members = [
        "user:data.engineer@example.com",
        "serviceAccount:data-pipeline@my-gcp-project-id.iam.gserviceaccount.com",
      ]
    }
  }

  storage_bucket_bindings = {
    // Authoritatively sets the Object Admin for a specific bucket
    "bucket_object_admin" = {
      bucket  = "my-secure-data-bucket"
      role    = "roles/storage.objectAdmin"
      members = [
        "serviceAccount:data-pipeline@my-gcp-project-id.iam.gserviceaccount.com",
      ]
    }
  }

  organization_members = {
    // Additively grants billing user role at the organization level
    "org_billing_users" = {
      org_id  = "123456789012"
      role    = "roles/billing.user"
      members = [
        "group:finance-team@example.com",
      ]
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_folder_bindings"></a> [folder\_bindings](#input\_folder\_bindings) | A map of authoritative folder-level IAM bindings to create. The key of the map is a logical name for the binding. Authoritative bindings overwrite any existing members for the given role. The `folder` attribute must be in the format 'folders/{folder\_id}'. | <pre>map(object({<br>    folder  = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_folder_members"></a> [folder\_members](#input\_folder\_members) | A map of non-authoritative folder-level IAM members to create. The key of the map is a logical name for the binding. Non-authoritative members will be added to a role without overwriting existing ones. The `folder` attribute must be in the format 'folders/{folder\_id}'. | <pre>map(object({<br>    folder  = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_organization_bindings"></a> [organization\_bindings](#input\_organization\_bindings) | A map of authoritative organization-level IAM bindings to create. The key of the map is a logical name for the binding. Authoritative bindings overwrite any existing members for the given role. The `org_id` attribute must be a numeric string. | <pre>map(object({<br>    org_id  = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_organization_members"></a> [organization\_members](#input\_organization\_members) | A map of non-authoritative organization-level IAM members to create. The key of the map is a logical name for the binding. Non-authoritative members will be added to a role without overwriting existing ones. The `org_id` attribute must be a numeric string. | <pre>map(object({<br>    org_id  = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_project_bindings"></a> [project\_bindings](#input\_project\_bindings) | A map of authoritative project-level IAM bindings to create. The key of the map is a logical name for the binding. Authoritative bindings overwrite any existing members for the given role. If `project` is not provided, the provider's default project is used. | <pre>map(object({<br>    project = optional(string)<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_project_members"></a> [project\_members](#input\_project\_members) | A map of non-authoritative project-level IAM members to create. The key of the map is a logical name for the binding. Non-authoritative members will be added to a role without overwriting existing ones. If `project` is not provided, the provider's default project is used. | <pre>map(object({<br>    project = optional(string)<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_pubsub_topic_bindings"></a> [pubsub\_topic\_bindings](#input\_pubsub\_topic\_bindings) | A map of authoritative Pub/Sub topic-level IAM bindings to create. The key of the map is a logical name for the binding. Authoritative bindings overwrite any existing members for the given role. If `project` is not provided, the provider's default project is used. | <pre>map(object({<br>    project = optional(string)<br>    topic   = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_pubsub_topic_members"></a> [pubsub\_topic\_members](#input\_pubsub\_topic\_members) | A map of non-authoritative Pub/Sub topic-level IAM members to create. The key of the map is a logical name for the binding. Non-authoritative members will be added to a role without overwriting existing ones. If `project` is not provided, the provider's default project is used. | <pre>map(object({<br>    project = optional(string)<br>    topic   = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_service_account_bindings"></a> [service\_account\_bindings](#input\_service\_account\_bindings) | A map of authoritative service account-level IAM bindings to create. The key of the map is a logical name for the binding. Authoritative bindings overwrite any existing members for the given role. The `service_account_id` attribute must be the fully-qualified name (e.g., 'projects/{project}/serviceAccounts/{email}'). | <pre>map(object({<br>    service_account_id = string<br>    role               = string<br>    members            = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_service_account_members"></a> [service\_account\_members](#input\_service\_account\_members) | A map of non-authoritative service account-level IAM members to create. The key of the map is a logical name for the binding. Non-authoritative members will be added to a role without overwriting existing ones. The `service_account_id` attribute must be the fully-qualified name. | <pre>map(object({<br>    service_account_id = string<br>    role               = string<br>    members            = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_storage_bucket_bindings"></a> [storage\_bucket\_bindings](#input\_storage\_bucket\_bindings) | A map of authoritative storage bucket-level IAM bindings to create. The key of the map is a logical name for the binding. Authoritative bindings overwrite any existing members for the given role. | <pre>map(object({<br>    bucket  = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |
| <a name="input_storage_bucket_members"></a> [storage\_bucket\_members](#input\_storage\_bucket\_members) | A map of non-authoritative storage bucket-level IAM members to create. The key of the map is a logical name for the binding. Non-authoritative members will be added to a role without overwriting existing ones. | <pre>map(object({<br>    bucket  = string<br>    role    = string<br>    members = set(string)<br>    condition = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_folder_bindings"></a> [folder\_bindings](#output\_folder\_bindings) | A map of the created folder-level IAM bindings, keyed by the logical name provided in the input variable. |
| <a name="output_folder_members"></a> [folder\_members](#output\_folder\_members) | A map of the created folder-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag. |
| <a name="output_organization_bindings"></a> [organization\_bindings](#output\_organization\_bindings) | A map of the created organization-level IAM bindings, keyed by the logical name provided in the input variable. |
| <a name="output_organization_members"></a> [organization\_members](#output\_organization\_members) | A map of the created organization-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag. |
| <a name="output_project_bindings"></a> [project\_bindings](#output\_project\_bindings) | A map of the created project-level IAM bindings, keyed by the logical name provided in the input variable. |
| <a name="output_project_members"></a> [project\_members](#output\_project\_members) | A map of the created project-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag. |
| <a name="output_pubsub_topic_bindings"></a> [pubsub\_topic\_bindings](#output\_pubsub\_topic\_bindings) | A map of the created Pub/Sub topic-level IAM bindings, keyed by the logical name provided in the input variable. |
| <a name="output_pubsub_topic_members"></a> [pubsub\_topic\_members](#output\_pubsub\_topic\_members) | A map of the created Pub/Sub topic-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag. |
| <a name="output_service_account_bindings"></a> [service\_account\_bindings](#output\_service\_account\_bindings) | A map of the created service account-level IAM bindings, keyed by the logical name provided in the input variable. |
| <a name="output_service_account_members"></a> [service\_account\_members](#output\_service\_account\_members) | A map of the created service account-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag. |
| <a name="output_storage_bucket_bindings"></a> [storage\_bucket\_bindings](#output\_storage\_bucket\_bindings) | A map of the created storage bucket-level IAM bindings, keyed by the logical name provided in the input variable. |
| <a name="output_storage_bucket_members"></a> [storage\_bucket\_members](#output\_storage\_bucket\_members) | A map of the created storage bucket-level IAM members, keyed by the logical name provided in the input variable. The `members` attribute is a map from member name to the created resource's etag. |

## Requirements

### Terraform

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.54.0 |

### APIs

The following APIs must be enabled on the project where the provider is authenticated:

-   Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`
-   Identity and Access Management (IAM) API: `iam.googleapis.com`
-   Cloud Pub/Sub API: `pubsub.googleapis.com`
-   Cloud Storage API: `storage.googleapis.com`

### Roles

The service account or user running Terraform must have the necessary IAM permissions to manage policies on the target resources. Common roles include:

-   **Organization:** `roles/resourcemanager.organizationAdmin`
-   **Folder:** `roles/resourcemanager.folderIamAdmin`
-   **Project:** `roles/resourcemanager.projectIamAdmin`
-   **Service Account:** `roles/iam.serviceAccountAdmin`
-   **Pub/Sub Topic:** `roles/pubsub.admin`
-   **Storage Bucket:** `roles/storage.admin`
