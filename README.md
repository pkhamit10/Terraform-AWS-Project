# 🛠️ AWS Infrastructure Provisioning with Terraform

This repository contains Terraform configurations to **provision and manage AWS infrastructure** in a scalable, repeatable, and automated way. It demonstrates Infrastructure as Code (IaC) best practices, enabling teams to easily spin up, update, and destroy cloud environments with minimal manual intervention.

---

## 📁 Project Overview

Terraform is an open-source tool to define cloud and on-premises resources in human-readable configuration files that can version, reuse, and share. With these configurations, create and manage AWS infrastructure such as:

- Virtual Private Clouds (VPCs)
- Subnets, Route Tables, and Internet Gateways
- Security Groups and IAM Roles
- EC2 Instances and Auto Scaling Groups
- S3 Buckets and CloudFront Distributions
- RDS Databases and more

This project demonstrates how to configure, initialize, and deploy these resources using Terraform.

---

## 🧰 Prerequisites

Before using this project, ensure the following tools are installed locally:

- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.5.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) >= 2.0
- Git
- An AWS account with appropriate IAM permissions

Also, make sure your AWS credentials are configured locally:
```bash
aws configure
