# DevOps Assignment - AWS Infrastructure

## Project Structure
```
infrastructure/
├── terraform/
│   ├── aws-dev/
│   ├── aws-staging/
│   └── aws-prod/
└── docker/
    └── Dockerfile.backend
```

## AWS Infrastructure Overview

Each environment (dev, staging, prod) consists of:

- VPC with public and private subnets across 2 availability zones
- ECS Fargate cluster for containerized backend
- Application Load Balancer for traffic distribution
- Auto Scaling Group for automatic scaling based on CPU/Memory
- S3 bucket for frontend static assets
- CloudFront CDN for global content delivery
- ECR repository for Docker images
- CloudWatch logs for monitoring

## State Management

Terraform state is stored in S3 with DynamoDB locking enabled:

- Bucket: `terraform-state-aws-devops-[timestamp]`
- State files: `devops-assignment/dev/`, `devops-assignment/staging/`, `devops-assignment/prod/`
- Lock table: `terraform-lock`
- Region: `ap-south-1` (Primary), `ap-south-2` (Fallback)

## Deployment

### Prerequisites

- AWS CLI configured with credentials
- Terraform installed (v1.0+)
- Docker installed

### Initialize
```bash
cd infrastructure/terraform/aws-dev
terraform init
terraform validate
```

### Deploy
```bash
terraform plan -out=dev.plan
terraform apply dev.plan
```

### Outputs

After deployment, outputs include:

- ALB DNS name for backend access
- CloudFront domain for frontend
- ECR repository URL
- S3 bucket name

## Environments

Dev, Staging, and Prod are completely isolated with different:

- Instance counts
- CPU/Memory allocation
- Auto-scaling limits
- Logging retention

Deploy to each environment separately using respective tfvars files.
