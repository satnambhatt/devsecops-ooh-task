# `checkov` Scan Report 

```bash
terraform scan results:

Passed checks: 12, Failed checks: 0, Skipped checks: 1

Check: CKV_AWS_358: "Ensure AWS GitHub Actions OIDC authorization policies only allow safe claims and claim order"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/iam-358
Check: CKV_AWS_108: "Ensure IAM policies does not allow data exfiltration"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/ensure-iam-policies-do-not-allow-data-exfiltration
Check: CKV_AWS_111: "Ensure IAM policies does not allow write access without constraints"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/ensure-iam-policies-do-not-allow-write-access-without-constraint
Check: CKV_AWS_49: "Ensure no IAM policies documents allow "*" as a statement's actions"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-iam-43
Check: CKV_AWS_107: "Ensure IAM policies does not allow credentials exposure"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/ensure-iam-policies-do-not-allow-credentials-exposure
Check: CKV_AWS_356: "Ensure no IAM policies documents allow "*" as a statement's resource for restrictable actions"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-356
Check: CKV_AWS_109: "Ensure IAM policies does not allow permissions management / resource exposure without constraints"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/ensure-iam-policies-do-not-allow-permissions-management-resource-exposure-without-constraint
Check: CKV_AWS_283: "Ensure no IAM policies documents allow ALL or any AWS principal permissions to the resource"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/bc-aws-283
Check: CKV_AWS_1: "Ensure IAM policies that allow full "*-*" administrative privileges are not created"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/iam-23
Check: CKV_AWS_110: "Ensure IAM policies does not allow privilege escalation"
        PASSED for resource: aws_iam_policy_document.bucket-policy
        File: /data.tf:3-29
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/aws-iam-policies/ensure-iam-policies-does-not-allow-privilege-escalation
Check: CKV_TF_2: "Ensure Terraform module sources use a tag with a version number"
        PASSED for resource: s3-server-bucket
        File: /main.tf:12-31
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/supply-chain-policies/terraform-policies/ensure-terraform-module-sources-use-tag
Check: CKV_AWS_41: "Ensure no hard coded AWS access key and secret key exists in provider"
        PASSED for resource: aws.default
        File: /providers.tf:1-10
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/aws-policies/secrets-policies/bc-aws-secrets-5
Check: CKV_TF_1: "Ensure Terraform module sources use a commit hash"
        SKIPPED for resource: s3-server-bucket
        Suppress comment: Ensure Terraform module sources use a commit hash
        File: /main.tf:12-31
        Guide: https://docs.prismacloud.io/en/enterprise-edition/policy-reference/supply-chain-policies/terraform-policies/ensure-terraform-module-sources-use-git-url-with-commit-hash-revision
```