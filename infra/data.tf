data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bucket-policy" {
  statement {
    sid = "AllowAmplifyToAccessBucket"
    principals {
      type        = "Service"
      identifiers = ["amplify.amazonaws.com"]
    }

    actions = [
      "s3:ListBucket",
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${local.project_name}-${local.env}",
      "arn:aws:s3:::${local.project_name}-${local.env}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values = [
        "${local.account_id}"
      ]
    }
  }
}