module "cloudfront" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "5.0.0"

  comment     = "CloudFront distribution for BMI Calculator App used for oOh! Media"
  enabled     = true
  price_class = "PriceClass_All"
  staging     = false

  create_origin_access_control = true
  origin_access_control = {
    s3_server_bucket = {
      description      = "CloudFront access to S3 Server Bucket"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin = {
    s3_server_bucket = {
      domain_name           = module.s3-server-bucket.s3_bucket_bucket_regional_domain_name
      origin_access_control = "s3_server_bucket"
    }
  }

  default_cache_behavior = {
    target_origin_id       = "s3_server_bucket"
    viewer_protocol_policy = "https-only"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/"
      target_origin_id       = "s3_server_bucket"
      viewer_protocol_policy = "https-only"

      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  tags = local.tags

}

module "s3-server-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.11.0"

  bucket                  = "${local.project_name}-${local.env}"
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  website = {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = local.tags
}

# Add CORS configuration after CloudFront is created to avoid the Circular Dependency error.
resource "aws_s3_bucket_cors_configuration" "s3_server_bucket_cors" {
  bucket = module.s3-server-bucket.s3_bucket_id

  cors_rule {
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["https://${module.cloudfront.cloudfront_distribution_domain_name}"]
    allowed_headers = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }

  depends_on = [module.cloudfront]
}

# module "s3-logging-bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "5.3.1"

#   bucket = "${local.project_name}-logs"

#   control_object_ownership = true

#   attach_access_log_delivery_policy     = true

#   access_log_delivery_policy_source_accounts      = [data.aws_caller_identity.current.account_id]
# }