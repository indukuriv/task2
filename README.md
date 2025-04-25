# LightFeather DevOps Coding Challenge

This repository contains all code and configuration needed to deploy a React frontend and Express backend to AWS ECS via Terraform, and to build/deploy via a Jenkins pipeline.

---

## Table of Contents

1. [Overview]
2. [Prerequisites]
3. [Repository Structure]
4. [Local Docker Build & Smoke Test]
5. [Terraform Infrastructure for Applications]
   - [Modules Layout]
   - [Root Configuration]
6. [Deploying Terraform]
7. [Manual AWS Setup (Jenkins, ECR, IAM)]
8. [Jenkins Pipeline]
   - [Jenkinsfile Overview]
   - [Creating the Jenkins Job]
9. [Running the Pipeline]
10. [Post-Deploy Verification]

---

## Overview

- **Objective**: Deploy a React frontend and Express backend as containers on AWS ECS Fargate with an Application Load Balancer, automated via Jenkins.
- **Terraform** manages all infra for VPC, subnets, ECS cluster, ALB, target groups, and services.
- **Jenkins, ECR repos,** and **IAM roles** for Jenkins are created manually (documented below).

---

## Prerequisites

On your **local** machine or Jenkins agent:

- Git
- Node.js v16 + npm
- Docker Desktop (or Docker Engine)
- AWS CLI v2 (configured via `aws configure`)
- Terraform v1.x
- (Optional) unzip, wget, curl

---

## Local Docker Build & Smoke Test

1. **Build backend**:
   ```bash
   cd backend
   docker build -t backend-test:1 .
   ```
2. **Build frontend**:
   ```bash
   cd ../frontend
   docker build -t frontend-test:1 .
   ```
3. **Run & test**:
   ```bash
   docker run -d --rm --name be-test -p 8080:8080 backend-test:1
   sleep 10
   curl -f http://localhost:8080
   docker stop be-test

   docker run -d --rm --name fe-test -p 3000:3000 frontend-test:1
   sleep 10
   curl -f http://localhost:3000
   docker stop fe-test
   ```

If both respond without errors, you’re ready for AWS.

---

## Terraform Infrastructure for Applications

### Modules Layout

- **vpc**: VPC, public subnets, IGW, route tables
- **alb**: Security group, ALB, two target groups (frontend, backend), listener and path rule
- **ecs_cluster**: ECS Fargate cluster
- **ecs_service**: IAM exec role, task definition, ECS service referencing a TG

Each module folder has `main.tf`, `variables.tf`, and `outputs.tf`.

### Root Configuration (`infrastructure/`)

- **variables.tf**: AWS region, VPC CIDR, AZs, subnet CIDRs, cluster & app names, image URIs, ports, counts
- **main.tf**: Calls each module in order: `vpc`, `alb`, `ecs_cluster`, two `ecs_service` (backend & frontend)
- **outputs.tf**: Exposes `alb_dns`, `frontend_url`, and `backend_api_url`

---

## Deploying Terraform

1. **Init & Plan**:
   ```bash
   cd infrastructure
   terraform init
   terraform plan \
     -var="backend_image=<ECR_BACKEND>:latest" \
     -var="frontend_image=<ECR_FRONTEND>:latest"
   ```
2. **Apply**:
   ```bash
   terraform apply -auto-approve
   ```
3. Note the **ALB DNS** in the outputs.

---

## Manual AWS Setup (Jenkins, ECR, IAM)

1. **ECR Repositories**: Create `lf-backend` & `lf-frontend` in AWS ECR.
2. **IAM Role for Jenkins**:
   - Trusted entity: EC2
   - Attach: `AmazonEC2ContainerRegistryFullAccess`, `AmazonECS_FullAccess`, `AmazonVPCReadOnlyAccess` (optional)
   - Name: `JenkinsMasterRole`
3. **Jenkins EC2**:
   - Launch Amazon Linux 2 AMI with `JenkinsMasterRole`, open ports 22, 8080, 50000.
   - **User-Data** (will install all prerequisites):
     ```bash
     #!/bin/bash
     yum update -y
     amazon-linux-extras install docker -y
     systemctl enable --now docker
     usermod -aG docker jenkins
     yum install -y git unzip
     curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip
     unzip -q awscliv2.zip && ./aws/install
     TERRAFORM_VERSION=1.4.6
     wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
     unzip -q terraform_${TERRAFORM_VERSION}_linux_amd64.zip && mv terraform /usr/local/bin/
     curl -sL https://rpm.nodesource.com/setup_16.x | bash -
     yum install -y nodejs
     ```
   - On startup Jenkins will have Docker, Git, AWS CLI, Terraform, Node.js installed.

---

## Jenkins Pipeline

### Jenkinsfile Overview

The provided `Jenkinsfile` performs:

1. **Install Prerequisites** (Docker, Git, AWS CLI, Terraform, Node.js) if missing
2. **Checkout** the Git repo
3. **Docker Build & Smoke Test** for both services
4. **Tag & Push** images to ECR with build number as tag
5. **Terraform** init, plan (with new image URIs), and apply
6. **Post-Deploy**: prints the ALB DNS URL for frontend and backend

### Creating the Jenkins Job

1. In Jenkins UI → **New Item** → **Pipeline**
2. Under **Pipeline** → **Definition**, choose **Pipeline script from SCM**
3. Set **SCM** to **Git**, enter your repo URL and credentials
4. **Script Path**: `Jenkinsfile`
5. Save and **Build Now**

---

## Running the Pipeline

- Each build will install missing tools, build & test containers, push to ECR, and deploy via Terraform.
- Monitor the build logs in Jenkins for status and errors.

---

## Post-Deploy Verification

1. Visit the **Frontend URL**: `http://<ALB_DNS>` → should display “SUCCESS <guid>”.
2. Test the API: `curl http://<ALB_DNS>/api` → should return JSON/guid.

---

Good luck!