# BMI Calculator App - oOh! Media

This application is taken from [bmi-calculator](https://github.com/GermaVinsmoke/bmi-calculator?tab=readme-ov-file). It is deployed in a secured AWS Serverless (low cost) environment. 

## Table of Contents 
- [BMI Calculator App - oOh! Media](#bmi-calculator-app---ooh-media)
  - [Table of Contents](#table-of-contents)
  - [Initial Pull of remote repository](#initial-pull-of-remote-repository)
  - [Architecture on AWS](#architecture-on-aws)
  - [Executing it Locally](#executing-it-locally)
  - [Deploying it to the Cloud](#deploying-it-to-the-cloud)
    - [IaC Commands](#iac-commands)

---
## Initial Pull of remote repository
On the initial pull, there were 100+ vulnerabilities that were installed from the `package.json` file. This was due to the bmi-calculator being a 5 year old project. 
```
169 vulnerabilities (12 low, 62 moderate, 73 high, 22 critical)
```

The fix was to execute `npm audit fix --force` and update the packages which has no vulnerabilities. A detailed report can be found in [Initial Vulnerability Report](/docs/initial-vulnerability-report.md) document. 

## Architecture on AWS
Services used: 

- AWS Amplify App
- AWS S3 Bucket
- AWS Route53 for DNS Resolution (Optional)

![](/docs/)


## Executing it Locally

To run the application locally, you can: 
```bash
cd app

npm clean-install

npm start
```

or if you want to run the production build you can use `serve` helps you serve a static site, single page application. 
```bash
cd app

npm install -g serve

serve -s build
```

## Deploying it to the Cloud
<!-- Due to the nature of the setup, you can only deploy to AWS cloud via the `main` branch. This repository follows the GitFlow  -->
The code to deployment in the cloud is located in [infra](/infra/) folder. I am using Terraform to deploy S3 bucket used for a static website which is exposed via CloudFront Distribution. 

I have used trusted [terraform aws modules](https://github.com/terraform-aws-modules) which are widely used by the community. The plans generated from the modules is scanned using [checkov](https://www.checkov.io/) to check for any misconfigurations as recommended by the best practices. 

The benefits: 
- Cheap and cost-effective.
- Cloudfront supports HTTPS/SSL for secure content delivery.
- Securing the S3 bucket but only allowing access from CloudFront. 
- Content caching for quick response on CloudFront.
- Can place a WAF firewall between CloudFront and S3 bucket to filter out requests.

Pre-reqs: 
- [Install terraform cli](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [Install checkov](https://www.checkov.io/2.Basics/Installing%20Checkov.html)
- Install `jq`
- Create a `ENV.tfvars` file to store the project variables. Review sample [here](/infra/README.md).

### IaC Commands 
- Lint check
```bash
cd infra

terraform fmt -check && echo $?

# Will return 0 if there are no formatting issues. OR 
# Will return the file name with the formatting issues.
```

- checkov scan 
```bash
checkov -d infra/ 
```

- To view the terraform plan
```bash
cd infra
terraform plan -var-file=VAR_FILE_NAME.tfvars
```

- To apply the terraform plan
```bash
cd infra
terraform apply -var-file=VAR_FILE_NAME.tfvars
```