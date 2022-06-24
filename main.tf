/**
 * ## Usage
 *
 * Creates an IAM role for use as a CodePipeline service role.
 *
 * ```hcl
 * module "codepipeline_iam_role" {
 *   source = "dod-iac/codepipeline-iam-role/aws"
 *
 *   name                     = format("app-%s-codepipeline-iam-role-%s", var.application, var.environment)
 *   codebuild_projects_start = ["*"]
 *   codecommit_repos_watch   = ["*"]
 *   s3_buckets_artifacts     = ["*"]
 *   tags               = {
 *     Application = var.application
 *     Environment = var.environment
 *     Automation  = "Terraform"
 *   }
 * }
 * ```
 *
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 */

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

#
# IAM
#

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "codepipeline.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "main" {
  name               = var.name
  assume_role_policy = length(var.assume_role_policy) > 0 ? var.assume_role_policy : data.aws_iam_policy_document.assume_role_policy.json
  tags               = var.tags
}

data "aws_iam_policy_document" "main" {
  dynamic "statement" {
    for_each = length(var.codecommit_repos_watch) > 0 ? [1] : []
    content {
      sid = "WatchCodeCommitRepo"
      actions = [
        "codecommit:GetBranch",
        "codecommit:GetCommit",
        "codecommit:UploadArchive",
        "codecommit:GetUploadArchiveStatus",
        "codecommit:CancelUploadArchive"
      ]
      effect    = "Allow"
      resources = contains(var.codecommit_repos_watch, "*") ? ["*"] : var.codecommit_repos_watch
    }
  }
  dynamic "statement" {
    for_each = length(var.codebuild_projects_start) > 0 ? [1] : []
    content {
      sid = "StartCodeBuildProject"
      actions = [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ]
      effect    = "Allow"
      resources = contains(var.codebuild_projects_start, "*") ? ["*"] : var.codebuild_projects_start
    }
  }
  dynamic "statement" {
    for_each = length(var.s3_buckets_artifacts) > 0 ? [1] : []
    content {
      sid = "ListBucket"
      actions = [
        "s3:GetBucketLocation",
        "s3:GetBucketRequestPayment",
        "s3:GetEncryptionConfiguration",
        "s3:ListBucket",
        "s3:ListBucketMultipartUploads"
      ]
      effect    = "Allow"
      resources = contains(var.s3_buckets_artifacts, "*") ? ["*"] : var.s3_buckets_artifacts
    }
  }
  dynamic "statement" {
    for_each = length(var.s3_buckets_artifacts) > 0 ? [1] : []
    content {
      sid = "GetAndPutObjects"
      actions = [
        "s3:GetObject",
        "s3:GetObjectAcl",
        "s3:GetObjectVersion",
        "s3:PutObject",
        "s3:PutObjectAcl",
        "s3:AbortMultipartUpload",
        "s3:ListMultipartUploadParts"
      ]
      effect    = "Allow"
      resources = contains(var.s3_buckets_artifacts, "*") ? ["*"] : formatlist("%s/*", var.s3_buckets_artifacts)
    }
  }
}

resource "aws_iam_policy" "main" {
  count = length(var.codecommit_repos_watch) > 0 || length(var.codebuild_projects_start) > 0 || length(var.s3_buckets_artifacts) > 0 ? 1 : 0

  name        = length(var.policy_name) > 0 ? var.policy_name : format("%s-policy", var.name)
  description = length(var.policy_description) > 0 ? var.policy_description : format("The policy for %s.", var.name)
  policy      = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role_policy_attachment" "main" {
  count = length(var.codecommit_repos_watch) > 0 || length(var.codebuild_projects_start) > 0 || length(var.s3_buckets_artifacts) > 0 ? 1 : 0

  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.0.arn
}
