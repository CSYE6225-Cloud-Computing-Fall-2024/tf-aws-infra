# Terraform-AWS-Infrastructure as Code
Repository for course CSYE 6225 Network Structures and Cloud Computing offered by Northeastern University and taken in Fall 2024. This repository deals with using Terraform as infrastructure as Code platform and sets up Virtual Private Cloud (VPC) on AWS.

# How to run the application
- Install AWS cli and Terraform
- Run below command to set up AWS credentials on local device
  - aws configure --profile= YOUR_PROFILE_NAME
- Navigate to project repository on command line and run below Terraform commands
  - Initialize the repository: terraform init
  - Perform validation checks: terraform validate
  - Create execution plan: terraform plan
  - Apply changes mentioned in execution plan: terraform apply
  - Destroy existing vpc: terraform destroy
