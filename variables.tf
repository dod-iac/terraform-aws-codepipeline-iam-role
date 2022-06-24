variable "assume_role_policy" {
  type        = string
  description = "The assume role policy for the AWS IAM role.  If blank, allows CodePipeline to assume the role."
  default     = ""
}

variable "name" {
  type        = string
  description = "The name of the AWS IAM role."
}

variable "policy_description" {
  type        = string
  description = "The description of the AWS IAM policy. Defaults to \"The policy for [NAME]\"."
  default     = ""
}

variable "policy_name" {
  type        = string
  description = "The name of the AWS IAM policy.  Defaults to \"[NAME]-policy\"."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to the AWS IAM role."
  default     = {}
}

variable "codebuild_projects_start" {
  type        = list(string)
  description = "The ARNs of the CodeBuild projects that the pipeline will run.  Use [\"*\"] to allow all CodeBuild projects."
  default     = []
}

variable "codecommit_repos_watch" {
  type        = list(string)
  description = "The ARNs of the CodeCommit repos that the pipeline will watch.  Use [\"*\"] to allow all CodeCommit repos."
  default     = []
}

variable "s3_buckets_artifacts" {
  type        = list(string)
  description = "The ARNs of the AWS S3 buckets that will be used by the pipeline for storing input and output artifacts.  Use [\"*\"] to allow all S3 buckets."
  default     = []
}
