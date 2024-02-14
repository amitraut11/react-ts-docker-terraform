

/*Terraform typically uses a backend to store its state files. 
The state file contains information about the resources managed by Terraform, their current configuration, and their relationships. 
This state file is crucial for Terraform to understand the current state of your infrastructure so that it can plan and execute changes effectively. */

resource "aws_s3_bucket" "codepipeline_new_artifacts_to_manage_state" {
  bucket = "pipeline-new-artifacts-state-management-terraform"
  acl    = "private"
} 