locals {
  project_name = var.project_name
  env          = var.env
  account_id   = data.aws_caller_identity.current.account_id

  app_build_dir = "../app/build"

  tags = merge(var.tags, {
    Environment = local.env
    Project     = "BMI Calculator App"
    ManagedBy   = "Terraform"
  })
}