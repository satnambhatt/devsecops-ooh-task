# CI CD for this Application 

## Continuous Integration
1. Lint check of the application and formatting check of IaC
2. Run unit tests for the application 
3. Run validate inputs for IaC
4. Run infrastructure misconfiguration check
5. Run security scans such as static code analysis and vulnerability check
6. Build the application 

## Continuous Deployment 
1. Apply the terraform changes
2. Monitor the deployment

## GitHub Actions Workflow

Please do note, this is my first time reviewing GitHub actions. 

```yaml
name: CI/CD Pipeline
run-name: ${{ github.actor }} is making changes
on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main
jobs:
  deploy-app:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - uses: actions/setup-python@v4
        with: 
          python-version: 3.8
      - name: Setup Terraform 
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: 1.12.2
      - name: Install dependencies
        run: npm clean-install
        working-directory: app
      - name: Run unit tests
        run: npm run tests
        working-directory: app
        continue-on-error: true # Workflow continues even if this fails
      - name: Terraform init
        run: terraform init
        working-directory: infra
      - name: Validate Infra with Checkov
        uses: bridgecrewio/checkov-action@master
        with: 
          directory: infra
          framework: terraform
      - name: Terraform Validate 
        run: terraform fmt -check && terraform validate
      - name: Terraform Plan 
        run: terraform plan
      - name: Terraform apply
        if: github.event_name == 'push' && github.ref == 'refs/heads/main'
        run:  terraform apply -auto-approve
```