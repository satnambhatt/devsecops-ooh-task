variable "aws_account_id" {
  type        = string
  description = "The AWS account ID to deploy to."

  validation {
    condition     = length(var.aws_account_id) == 12
    error_message = "The AWS account ID must be 12 digits long."
  }
}

variable "role_name" {
  type        = string
  description = "The name of the role to assume."
}

variable "project_name" {
  type        = string
  description = "The name of the project."
}

variable "state_bucket" {
  type        = string
  description = "The name of the S3 bucket to store the Terraform state."
}

variable "env" {
  type        = string
  description = "The environment to deploy to."
  default     = "sandbox"

  validation {
    condition     = contains(["sandbox", "dev", "test", "prod"], var.env)
    error_message = "The environment must be either sandbox or production."
  }
}

variable "tags" {
  type        = map(string)
  description = "Tags to be applied to the resources."
  default     = {}
}