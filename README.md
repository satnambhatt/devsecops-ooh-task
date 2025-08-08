# BMI Calculator App - oOh! Media

This application is taken from [bmi-calculator](https://github.com/GermaVinsmoke/bmi-calculator?tab=readme-ov-file). It is deployed in a secured AWS Serverless (low cost) environment. 

## Table of Contents 
- [BMI Calculator App - oOh! Media](#bmi-calculator-app---ooh-media)
  - [Table of Contents](#table-of-contents)
  - [Initial Pull of remote repository](#initial-pull-of-remote-repository)
  - [Architecture on AWS](#architecture-on-aws)
  - [Executing it Locally](#executing-it-locally)
  - [Deploying it to the Cloud](#deploying-it-to-the-cloud)

---
## Initial Pull of remote repository
On the initial pull, there were 100+ vulnerabilities that were installed from the `package.json` file. This was due to the bmi-calculator being a 5 year old project. 
```
169 vulnerabilities (12 low, 62 moderate, 73 high, 22 critical)
```

The fix was to execute `npm audit fix --force` and update the packages which has no vulnerabilities. A detailed report can be found in [Initial Vulnerability Report](/docs/initial-vulnerability-report.md) document. 

## Architecture on AWS
Services used: 

- AWS 
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