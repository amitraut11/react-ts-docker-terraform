resource "aws_codebuild_project" "tf-plan" {
  name          = "tf-cicd-plan"
  description   = "Plan stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role-terraform.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.14.3"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("plan-buildspec.yml")
 }
}

resource "aws_codebuild_project" "tf-apply" {
  name          = "tf-cicd-apply"
  description   = "Apply stage for terraform"
  service_role  = aws_iam_role.tf-codebuild-role-terraform.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:1.4.4"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "SERVICE_ROLE"
    registry_credential{
        credential = var.dockerhub_credentials
        credential_provider = "SECRETS_MANAGER"
    }
 }
 source {
     type   = "CODEPIPELINE"
     buildspec = file("apply-buildspec.yml")
 }
}



# resource "aws_codebuild_project" "tf-image" {
#   name          = "tf-cicd-image"
#   description   = "Builds a Docker image and pushes it to ECR"
#   build_timeout = 60
#   service_role  = aws_iam_role.tf-codebuild-role-terraform.arn
 
# source {
#      type   = "CODEPIPELINE"
#      buildspec = file("image-buildspec.yml")
#  }

#   environment {
#     compute_type = "BUILD_GENERAL1_SMALL"
#     image        = "aws/codebuild/standard:5.0"  # Docker image with Terraform and other tools
#     type         = "LINUX_CONTAINER"
#     privileged_mode = true
#     #image_pull_credentials_type = "SERVICE_ROLE"
#     environment_variable {
#       name  = "DOCKER_REPO"
#       value = "https://hub.docker.com/u/amitraut11"  # Replace with your Docker repository URL
#     }
#     # registry_credential{
#     #     credential = var.dockerhub_credentials
#     #     credential_provider = "SECRETS_MANAGER"
#     # }
#   }

#   artifacts {
#     type = "CODEPIPELINE"
#   }
# }

resource "aws_codepipeline" "cicd_pipeline" {

    name = "tf-cicd"
    role_arn = aws_iam_role.tf-codepipeline-role-terraform.arn

    artifact_store {
        type="S3"
        location = aws_s3_bucket.codepipeline_artifacts_to_manage_state.id
    }

    stage {
        name = "Source"
        action{
            name = "Source"
            category = "Source"
            owner = "AWS"
            provider = "CodeStarSourceConnection"
            version = "1"
            output_artifacts = ["tf-code"]
            configuration = {
                FullRepositoryId = "amitraut11/codepipeline-terraform"
                BranchName   = "main"
                ConnectionArn = var.codestar_connector_credentials
                OutputArtifactFormat = "CODE_ZIP"
            }
        }
    }

    stage {
        name ="Plan"
        action{
            name = "Build"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-plan"
            }
        }
    }



    stage {
        name ="Apply"
        action{
            name = "Deploy"
            category = "Build"
            provider = "CodeBuild"
            version = "1"
            owner = "AWS"
            input_artifacts = ["tf-code"]
            configuration = {
                ProjectName = "tf-cicd-apply"
            }
        }
    }

    #  stage {
    #     name ="Image"
    #     action{
    #         name = "Image"
    #         category = "Build"
    #         provider = "CodeBuild"
    #         version = "1"
    #         owner = "AWS"
    #         input_artifacts = ["tf-code"]
    #         configuration = {
    #             ProjectName = "tf-cicd-image"
    #         }
    #     }
    # }

}