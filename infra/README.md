# Infra for Application 

Sample `.tfvars` file
```txt
env            = "NAME_OF_THE_ENVIRONMENT_DEPLOYING_TO"
role_name      = "NAME_OF_THE_DEPLOYMENT_ROLE"
state_bucket   = "NAME_OF_THE_STATE_FILE_S3_BUCKET"
project_name   = "NAME_OF_THE_PROJECT"
```

## Creating a `backend.tf` file
Before executing the terraform commands, create `backend.tf` file as below
```bash
terraform {
  backend "s3" {
    bucket       = "S3_STATE_BUCKET_NAME"
    encrypt      = true
    key          = "PATH_TO_STATE_FILE/ENVIRONMENT/tf.tfstate"
    region       = "AWS_REGION"
    use_lockfile = true
  }
}
```

## Input Variables 
| Variable Name | Type | Description | Required | 
| ------------- | ---- | ----------- | -------- | 
| aws_account_id | string | The AWS Account Id to deploy the resources into | yes | 
| role_name | string | The name of the role to assume | yes | 
| project_name | string | The name of the project. | yes | 
| state_bucket | string | The name of the S3 bucket to store the Terraform state files in | yes | 
| env | string | The environment to deploy the resources into, by default it will be `sandbox` and should only be `dev`, `test`, or `prod`| no | 
| tags | map(string) | The tags applied to the resources | no | 