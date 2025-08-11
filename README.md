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
  - [Security of the Application](#security-of-the-application)
  - [Security in the Cloud](#security-in-the-cloud)
  - [Future Improvements](#future-improvements)
    - [What security measures you would need to apply if it would need to handle the user authentication and sensitive data?](#what-security-measures-you-would-need-to-apply-if-it-would-need-to-handle-the-user-authentication-and-sensitive-data)

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

![](/docs/architecture-diagram.jpg)


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
- Create a `ENV.tfvars` and `backend.tf` file to store the project variables. Review sample [here](/infra/README.md).

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

## Security of the Application

The security of the application starts from the local terminal. Prior to executing the application, `npm audit` is run to check for vulnerabilities and fixed using `npm audit fix --force` while maintaining the integrity of the application. Additional scans using `trivy` was also conducted which resulted in 0 critical and 1 high in the `nth-check@1.0.2` which was being used in the `react-scripts@5.0.1` package. Since this was a 3 year old package, it had to be fixed by overriding it to the latest `2.1.1` version. 

The `postcss@^8.4.31` and `webpack-dev-server@^5.2.1` vulnerability can also be fixed by overriding it to the latest versions. 

```bash
# What the updated file can be like to resolve the vulnerabilities
  "overrides": {
    "nth-check": "^2.0.1",
    "postcss": "^8.4.31",
    "webpack-dev-server": "^5.2.1"
  }
```

A detailed CI/CD implementation is documented in [CI/CD Overview](/docs/cicd-overview.md). I was going to use GitHub actions with the project as I had already configured OIDC, but due to time boxing this project, I was unable to do it. 

To note: I have not investigated any further on the internals of the application, however, below is what I understand from it after a quick review. 

It is a javascript application built using the React framework. The application is using reacts state manager to render to the components on the webpage. The user data is stored in local storage as written in the helper function [`localStorage.js`](/app/src/helpers/localStorage.js). Storing data in local storage for production usage can lead to multiple security risks such as: 
- Lack of encryption
- More vulnerable to cross site scripting attacks
- Data can be easily tampered with

Enhancements and improvements to this are mentioned in the [Future Improments](#future-improvements) section.

## Security in the Cloud

The application is hosted on AWS Amplify which is an AWS Managed secure and scalable solution for static web hosting. The website is behind a password authentication to only allow restricted access. 

A WAF can also be implemented which is supported by AWS Amplify. The application is complied and built on the pipeline which is then published on a secure S3 bucket. There is no public access enabled for the bucket and only only specific roles can publish files to the S3 bucket. The S3 bucket also by default has resource based policy to allow only for TLSv1.3 requests and to deny any insecure connections. The resources are managed and deployed via Terraform which are pre-scanned using `checkov` for any misconfigurations. 

## Future Improvements
- Implement authentication mechanism for the individual users to login.
- Implement API Gateway to route traffic to backend APIs with additional WAF configurations. 
- Implement a backend layer using serverless deployed in a private subnets for database access. 
- Create a database and use server side session storage to retrieve information. 
- Currently, the deployment only happens for a single environment. In future, it would be ideal to have a multi environment deployment which can be done either via CDK, Terraform workspaces or Terragrunt/Terraform integration. For the purpose of this project it only deploys to a single environment.  
- Git hooks can be put in place to run tests on the developer machine. (Optional)

### What security measures you would need to apply if it would need to handle the user authentication and sensitive data?

User authentication can be done via Cognito using MFA. This will then create a JWT session token for the user to be able to interact with the application. The user information is to be stored in encrypted databases in secure subnets which only allow connectivity from limited resources. Not all AWS users should have access to that Databases and if access is required, it should only be granted for a short period of time. For more tightened security, encryption at rest can be implemented to store sensitive data. 

The input fields on the application can have input validation on the client and server side to ensure correct data is passed through. The backend APIs will be using lest privilege access. Since the proposed backed is to be in serverless, the OS patching is handled by AWS however, we would need to ensure our libraries are up-to date. 

WAFs can be placed in front to restrict IPs and locations to access the application. This will also prevent on rate limits and throttling of the APIs. 