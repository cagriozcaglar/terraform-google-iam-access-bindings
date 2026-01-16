# IAM Bindings Module: Complete Example

This example demonstrates the comprehensive use of the IAM Bindings module. It performs the following actions:

1.  Creates a new Google Cloud project.
2.  Creates a new folder under a specified organization.
3.  Creates a new Cloud Storage bucket in the project.
4.  Creates a new service account in the project.
5.  Instantiates the IAM Bindings module to apply a variety of roles to all the created resources, as well as at the organization level.
6.  Showcases both standard and conditional IAM bindings.

## How to use this example

To run this example, you need to have [Terraform](https://www.terraform.io/downloads.html) installed and be authenticated to a Google Cloud account with the necessary permissions to create projects, folders, and manage IAM policies.

1.  Clone the repository containing the module and navigate to this example directory.

2.  Initialize the Terraform working directory:
