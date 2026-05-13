# 🛒 Containerized E-Commerce Backend Platform

<div align="center">

![Architecture](ecommerce_architecture.png)

[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC?logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Container-Docker-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![AWS](https://img.shields.io/badge/Cloud-AWS-FF9900?logo=amazonaws&logoColor=white)](https://aws.amazon.com/)
[![GitHub Actions](https://img.shields.io/badge/CI%2FCD-GitHub%20Actions-2088FF?logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![Nginx](https://img.shields.io/badge/Proxy-Nginx-009639?logo=nginx&logoColor=white)](https://nginx.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A fully containerized, production-ready e-commerce backend platform deployed on AWS using **Infrastructure as Code**, automated **CI/CD pipelines**, and **Auto Scaling** for high availability.

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Prerequisites](#-prerequisites)
- [Getting Started](#-getting-started)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Infrastructure (Terraform)](#-infrastructure-terraform)
- [Environment Variables](#-environment-variables)
- [Contributing](#-contributing)

---

## 🌟 Overview

This project demonstrates a **containerized e-commerce web application** with a fully automated DevOps workflow. Every push to `main` triggers a GitHub Actions pipeline that builds a Docker image, pushes it to Amazon ECR, and deploys it across a highly available Auto Scaling Group — all infrastructure provisioned with Terraform.

**Key highlights:**

- **Zero-downtime deployments** via ASG instance refresh
- **Immutable infrastructure** — every deploy ships a fresh Docker image
- **Least-privilege IAM** — no hardcoded credentials anywhere
- **Repeatable environments** — Terraform manages every AWS resource

---

## 🏗 Architecture

The platform follows a standard AWS multi-AZ architecture:

```
GitHub Push
    │
    ▼
GitHub Actions (CI/CD)
    ├── docker build -t ecommerce-app .
    ├── aws ecr get-login-password | docker login
    ├── docker push <account>.dkr.ecr.<region>.amazonaws.com/ecommerce-app:latest
    └── aws autoscaling start-instance-refresh
            │
            ▼
    ┌───────────────────────────────────────────────┐
    │                  AWS Cloud                    │
    │  ┌─────────────────────────────────────────┐  │
    │  │                  VPC                    │  │
    │  │  ┌────────────┐      ┌────────────┐     │  │
    │  │  │  Subnet 1  │      │  Subnet 2  │     │  │
    │  │  │  EC2 + Nginx│◄────►│  EC2 + Nginx│   │  │
    │  │  │  Docker    │  ASG │  Docker    │     │  │
    │  │  └────────────┘      └────────────┘     │  │
    │  └─────────────────────────────────────────┘  │
    │  Amazon ECR          IAM Roles & Policies      │
    └───────────────────────────────────────────────┘
```

---

## 🛠 Tech Stack

| Category | Technology |
|----------|-----------|
| **Infrastructure as Code** | Terraform (HCL) |
| **Cloud Provider** | AWS (EC2, ECR, VPC, ASG, IAM) |
| **Containerization** | Docker |
| **CI/CD** | GitHub Actions |
| **Web Server / Proxy** | Nginx |
| **Frontend** | HTML, CSS, JavaScript |
| **Version Control** | Git & GitHub |

---

## 📁 Project Structure

```
Containerized-E-Commerce-Backend-Platform/
│
├── .github/
│   └── workflows/
│       └── deploy.yml          # GitHub Actions CI/CD pipeline
│
├── terraform/
│   ├── main.tf                 # Core AWS resource definitions
│   ├── variables.tf            # Input variables
│   └── outputs.tf              # Output values (IPs, ARNs, etc.)
│
├── css/                        # Stylesheets
├── js/                         # Frontend JavaScript
├── images/                     # Static assets
│
├── Dockerfile                  # Container image definition
├── index.html                  # Main application entry point
└── README.md
```

---

## ✅ Prerequisites

Before you begin, ensure you have the following installed and configured:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.0
- [Docker](https://docs.docker.com/get-docker/) >= 20.x
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- An AWS account with permissions for EC2, ECR, VPC, ASG, and IAM
- A GitHub account with Actions enabled on this repository

---

## 🚀 Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/Nada-Abdelghany/Containerized-E-Commerce-Backend-Platform.git
cd Containerized-E-Commerce-Backend-Platform
```

### 2. Provision AWS infrastructure with Terraform

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

This creates: VPC, subnets, Internet Gateway, EC2 launch template, Auto Scaling Group, Security Groups, IAM roles, and the ECR repository.

### 3. Build and run Docker locally

```bash
# Build
docker build -t ecommerce-app .

# Run locally
docker run -d -p 80:80 ecommerce-app
```

Visit `http://localhost` to view the application.

### 4. Push to Amazon ECR (manual)

```bash
# Authenticate
aws ecr get-login-password --region <your-region> | \
  docker login --username AWS --password-stdin \
  <account-id>.dkr.ecr.<region>.amazonaws.com

# Tag & push
docker tag ecommerce-app:latest \
  <account-id>.dkr.ecr.<region>.amazonaws.com/ecommerce-app:latest

docker push \
  <account-id>.dkr.ecr.<region>.amazonaws.com/ecommerce-app:latest
```

> **Note:** In normal workflow, the CI/CD pipeline handles steps 3 & 4 automatically on every push to `main`.

---

## ⚙️ CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/deploy.yml`) runs automatically on every push to `main`:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  1. Checkout    │───►│ 2. Build Image  │───►│ 3. ECR Login    │
│  git clone      │    │ docker build -t │    │ aws ecr login   │
└─────────────────┘    └─────────────────┘    └────────┬────────┘
                                                        │
              ┌─────────────────────────────────────────┘
              ▼
┌─────────────────┐    ┌─────────────────────────────┐
│ 4. Push to ECR  │───►│ 5. Deploy via ASG Refresh   │
│ docker push     │    │ aws autoscaling start-       │
│ image:latest    │    │ instance-refresh             │
└─────────────────┘    └─────────────────────────────┘
```

### Required GitHub Secrets

Set these in your repository under **Settings → Secrets and variables → Actions**:

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS IAM access key |
| `AWS_SECRET_ACCESS_KEY` | AWS IAM secret key |
| `AWS_REGION` | AWS region (e.g. `us-east-1`) |
| `ECR_REGISTRY` | ECR registry URL |
| `ECR_REPOSITORY` | ECR repository name |
| `ASG_NAME` | Auto Scaling Group name |

---

## 🌍 Infrastructure (Terraform)

All infrastructure is defined as code in the `terraform/` directory:

| Resource | Description |
|----------|-------------|
| **VPC** | Isolated network with CIDR `10.0.0.0/16` |
| **Public Subnets** | Two subnets across different AZs for HA |
| **Internet Gateway** | Allows public internet access |
| **Route Tables** | Routes traffic from subnets to IGW |
| **Security Groups** | Inbound HTTP/HTTPS, restricted SSH |
| **EC2 Launch Template** | Instance config with user-data to pull from ECR |
| **Auto Scaling Group** | Min 1 / Max 4 instances, instance refresh on deploy |
| **Amazon ECR** | Private Docker image registry |
| **IAM Role** | EC2 instance role with ECR pull permissions |

To tear down all resources:

```bash
cd terraform
terraform destroy
```

---

## 🔐 Environment Variables

The application uses the following environment variables (injected via EC2 user-data or `.env`):

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Application port | `80` |
| `NODE_ENV` | Environment mode | `production` |
| `APP_NAME` | Application display name | `E-Commerce Platform` |

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'Add some feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

<div align="center">



</div>
