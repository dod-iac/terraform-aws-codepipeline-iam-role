<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Usage

Creates an IAM role for use as a CodePipeline service role.

```hcl
module "codepipeline_iam_role" {
  source = "dod-iac/codepipeline-iam-role/aws"

  name                     = format("app-%s-codepipeline-iam-role-%s", var.application, var.environment)
  codebuild_projects_start = ["*"]
  codecommit_repos_watch   = ["*"]
  s3_buckets_artifacts     = ["*"]
  tags               = {
    Application = var.application
    Environment = var.environment
    Automation  = "Terraform"
  }
}
```

## Terraform Version

Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to main branch.

Terraform 0.11 and 0.12 are not supported.

## License

This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.0, < 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.0, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | The assume role policy for the AWS IAM role.  If blank, allows CodePipeline to assume the role. | `string` | `""` | no |
| <a name="input_codebuild_projects_start"></a> [codebuild\_projects\_start](#input\_codebuild\_projects\_start) | The ARNs of the CodeBuild projects that the pipeline will run.  Use ["*"] to allow all CodeBuild projects. | `list(string)` | `[]` | no |
| <a name="input_codecommit_repos_watch"></a> [codecommit\_repos\_watch](#input\_codecommit\_repos\_watch) | The ARNs of the CodeCommit repos that the pipeline will watch.  Use ["*"] to allow all CodeCommit repos. | `list(string)` | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the AWS IAM role. | `string` | n/a | yes |
| <a name="input_policy_description"></a> [policy\_description](#input\_policy\_description) | The description of the AWS IAM policy. Defaults to "The policy for [NAME]". | `string` | `""` | no |
| <a name="input_policy_name"></a> [policy\_name](#input\_policy\_name) | The name of the AWS IAM policy.  Defaults to "[NAME]-policy". | `string` | `""` | no |
| <a name="input_s3_buckets_artifacts"></a> [s3\_buckets\_artifacts](#input\_s3\_buckets\_artifacts) | The ARNs of the AWS S3 buckets that will be used by the pipeline for storing input and output artifacts.  Use ["*"] to allow all S3 buckets. | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to the AWS IAM role. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | The Amazon Resource Name (ARN) of the AWS IAM Role. |
| <a name="output_name"></a> [name](#output\_name) | The name of the AWS IAM Role. |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
