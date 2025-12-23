# Google Cloud IAM Member Module

This Terraform module provides a flexible and centralized way to manage additive IAM member bindings for various Google Cloud resources. It uses a single map variable to configure bindings for Projects, Cloud Storage Buckets, and Pub/Sub Topics, making it easy to manage permissions across different services.

The module creates individual `google_*_iam_member` resources for each member in a binding. This approach is additive and does not interfere with or remove existing IAM policies on the resources.

## Usage

Below is a basic example of how to use the module to grant different roles on different resources.

```hcl
module "iam_bindings" {
  source = "./path/to/module"

  bindings = {
    # Grant the Project Viewer role to a user and a group
    "project-viewers" = {
      resource_type = "project"
      resource_id   = "my-gcp-project-id"
      role          = "roles/viewer"
      members       = [
        "user:jane.doe@example.com",
        "group:viewers@example.com",
      ]
    }

    # Grant a Service Account the Storage Object Creator role on a bucket with a condition
    "storage-object-creators-us-only" = {
      resource_type = "storage_bucket"
      resource_id   = "my-important-bucket"
      role          = "roles/storage.objectCreator"
      members       = [
        "serviceAccount:my-app@my-gcp-project-id.iam.gserviceaccount.com",
      ]
      condition = {
        title       = "access_until_2025"
        expression  = "request.time < timestamp(\"2025-01-01T00:00:00Z\")"
        description = "Access is allowed only until the end of 2024."
      }
    }

    # Grant a Service Account the Pub/Sub Publisher role on a topic
    "pubsub-publishers" = {
      resource_type = "pubsub_topic"
      resource_id   = "projects/my-gcp-project-id/topics/my-topic"
      role          = "roles/pubsub.publisher"
      members       = [
        "serviceAccount:publisher-sa@my-gcp-project-id.iam.gserviceaccount.com",
      ]
    }
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bindings | A map of IAM bindings to create. The key of the map is a logical name for the binding. The value is an object with the following attributes:<br><br>- `resource_type`: (Required\|String) The type of resource to apply the binding to. Supported values are: `project`, `storage_bucket`, `pubsub_topic`.<br>- `resource_id`: (Required\|String) The identifier of the resource. For `project`, this is the project ID. For `storage_bucket`, this is the bucket name. For `pubsub_topic`, this is the full topic name (`projects/{project}/topics/{topic}`).<br>- `role`: (Required\|String) The IAM role to assign (e.g., `roles/storage.objectViewer`).<br>- `members`: (Required\|List of Strings) A list of members to grant the role to. See the [IAM Overview](https://cloud.google.com/iam/docs/overview#iam-principals) for a list of valid member types.<br>- `condition`: (Optional\|Object) An IAM condition block. It contains the following attributes:<br>  - `title`: (Required\|String) A title for the condition.<br>  - `description`: (Optional\|String) A description for the condition.<br>  - `expression`: (Required\|String) The Common Expression Language (CEL) expression. | <pre>map(object({<br>    resource_type = string<br>    resource_id   = string<br>    role          = string<br>    members       = list(string)<br>    condition     = optional(object({<br>      title       = string<br>      description = optional(string)<br>      expression  = string<br>    }))<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bindings | A map of the created IAM member bindings, keyed by the logical name provided in the input `bindings` variable. Each value contains the resource identifier, role, members, and the etag of the resource's IAM policy. |

## Requirements

### Terraform

| Name | Version |
|------|---------|
| terraform | >= 1.3 |

### Providers

| Name | Version |
|------|---------|
| google | ~> 5.0 |

### APIs

The project where this module is deployed must have the following APIs enabled:

- `cloudresourcemanager.googleapis.com`
- `iam.googleapis.com`

Depending on the `resource_type` used in the `bindings` variable, you may also need to enable the following APIs:

- `storage.googleapis.com` (for `storage_bucket`)
- `pubsub.googleapis.com` (for `pubsub_topic`)
