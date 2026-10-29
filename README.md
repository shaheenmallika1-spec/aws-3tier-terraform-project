# AWS 3-Tier Infrastructure with Terraform

## Overview

This project provisions a 3-tier web application infrastructure on AWS using Terraform. It demonstrates infrastructure as code, secure network design, application deployment, database connectivity, monitoring, and remote state management.

## Architecture

The application request flow is:

**User → Application Load Balancer → EC2 Application Tier → Amazon RDS**

- **Network:** Custom VPC across two Availability Zones, public and private subnets, route tables, Internet Gateway, and NAT Gateway.
- **Load balancing:** Application Load Balancer distributes incoming HTTP requests.
- **Application tier:** EC2 instances managed by an Auto Scaling Group.
- **Database tier:** Amazon RDS in private subnets.
- **Security:** Security groups, IAM roles, and AWS Systems Manager Session Manager.
- **Monitoring:** CloudWatch CPU alarms and CloudWatch Logs.
- **State management:** S3 remote Terraform state with encryption, versioning, and state locking.

## Technologies Used

- AWS
- Terraform
- Amazon VPC, EC2, ALB, Auto Scaling, and RDS
- AWS Systems Manager
- Amazon CloudWatch
- Amazon S3
- Python and Flask
- Linux
- Git and GitHub

## Repository Structure

```text
aws-3tier-terraform-project/
├── app/
│   ├── app.py
│   └── requirements.txt
├── scripts/
│   └── install-app.sh
└── terraform/
    ├── main.tf
    ├── provider.tf
    ├── variables.tf
    ├── versions.tf
    └── modules/
        ├── autoscaling/
        └── ec2/
```

```

## AWS Region

Sydney (`ap-southeast-2`)

## Deployment Workflow

Run Terraform commands from the Terraform root directory:

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan
```

Review the plan before applying any infrastructure changes.

```bash
terraform apply
```

**Important:** Review the proposed changes carefully before applying, especially when resources are already running.

## Validation

The following checks have been completed:

- Application health endpoint `/health` returned HTTP 200.
- Database connectivity endpoint `/db-health` returned HTTP 200.
- CloudWatch CPU alarm was deployed.
- CloudWatch Logs collection was configured on the existing application instance.
- Terraform remote state was migrated to S3.
- Project changes were committed and pushed to GitHub.

## Git Workflow

```bash
git status
git add .
git commit -m "Describe your changes"
git push origin main
```

## Cleanup

When the project is no longer needed, review the resources and costs in AWS. Back up any required data and inspect the Terraform destruction plan before running `terraform destroy`.

Do not delete the remote state bucket or state objects until you have confirmed that the infrastructure and state are no longer needed.

## Project Status

- [x] AWS CLI access verified
- [x] Terraform infrastructure deployed
- [x] Application and database connectivity verified
- [x] ALB and Auto Scaling configuration deployed
- [x] CloudWatch CPU alarm configured
- [x] CloudWatch Logs configured on the existing instance
- [x] S3 remote state configured
- [x] GitHub repository connected and changes pushed
- [ ] Final Terraform plan review
- [ ] Final documentation and repository review

## Learning Outcomes

This project demonstrates practical experience with Terraform modules, AWS networking, load balancing, private application and database tiers, IAM, remote state management, monitoring, and Git-based infrastructure workflows.
