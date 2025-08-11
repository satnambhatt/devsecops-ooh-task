resource "aws_amplify_app" "static-site" {
  name = "${var.project_name}-${var.env}"
  tags = local.tags
}

resource "aws_amplify_branch" "site" {
  app_id      = aws_amplify_app.static-site.id
  branch_name = var.env
  tags        = local.tags
}

module "s3-server-bucket" {
  #checkov:skip=CKV_TF_1:Ensure Terraform module sources use a commit hash
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.11.0"

  force_destroy = true

  bucket                  = "${local.project_name}-${local.env}"
  block_public_acls       = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_policy                         = true
  policy                                = data.aws_iam_policy_document.bucket-policy.json
  block_public_policy                   = true
  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  tags = local.tags
}

resource "aws_s3_object" "s3-server-bucket-object" {
  for_each = fileset("${local.app_build_dir}", "**")

  bucket = module.s3-server-bucket.s3_bucket_id
  key    = "build/${each.value}"
  source = "${local.app_build_dir}/${each.value}"
  etag   = filemd5("${local.app_build_dir}/${each.value}")
}

resource "null_resource" "deploy-app" {
  triggers = {
    id = timestamp()
  }

  provisioner "local-exec" {
    command = "aws amplify start-deployment --app-id ${aws_amplify_app.static-site.id} --branch-name ${var.env} --source-url s3://${local.project_name}-${local.env}/build/ --source-url-type BUCKET_PREFIX"
  }

  depends_on = [
    aws_amplify_app.static-site,
    aws_s3_object.s3-server-bucket-object
  ]
}