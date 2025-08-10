provider "aws" {
  region = "ap-southeast-2"

  # Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = ["${var.aws_account_id}"]

  assume_role {
    role_arn = "arn:aws:iam::${var.aws_account_id}:role/${var.role_name}"
  }
}

terraform {
  backend "s3" {
    bucket       = "terragrunt-remote-backend"
    encrypt      = true
    key          = "bmi-calculator/sandbox/tf.tfstate"
    region       = "ap-southeast-2"
    use_lockfile = true
  }
}

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.100.0" # Locking the version to avoid breaking changes from v6.0.0 and onwards
    }
  }
}
