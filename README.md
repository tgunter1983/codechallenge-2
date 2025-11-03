# AWS ECS Fargate "Hello World" Deployment

## 🧩 Overview
This project deploys an **NGINX Hello World container** on **AWS ECS Fargate** and provisions a secure **S3 bucket** with encryption, versioning, and public access blocking.

---

## 🏗️ Architecture
Resources created:
- ECS Cluster, Service, and Task Definition
- IAM Role for ECS Task Execution
- Security Group for HTTP traffic
- Private, encrypted, versioned S3 bucket

---

## ⚙️ Prerequisites
- Terraform >= 1.5.0
- AWS CLI >= 2.0
- AWS account with ECS, IAM, and S3 access

---

## 🚀 Deployment Steps

### 1️⃣ Initialize Terraform
```bash
terraform init
```

### 2️⃣ Validate Configuration
```bash
terraform fmt -check
terraform validate
```

### 3️⃣ Plan Deployment
```bash
terraform plan -out=tfplan
```

### 4️⃣ Apply Deployment
```bash
terraform apply tfplan
```

---

## 🌍 Access the Application
After deployment:
```bash
aws ecs list-tasks --cluster hello-world-cluster
aws ecs describe-tasks --cluster hello-world-cluster --tasks <task_id>
aws ec2 describe-network-interfaces --network-interface-ids <eni_id>
```
Open the public IP in your browser to see the NGINX Hello World page.

---

## 🧪 Terraform Testing
Run Terraform quality checks:
```bash
terraform fmt -recursive
terraform validate
terraform plan
terraform apply -auto-approve
terraform destroy -auto-approve
```

Optional Terraform Test Framework:
```bash
terraform test
```

Example test file: `tests/basic.tftest.hcl`
```hcl
run "plan" {
  command = ["terraform", "plan"]
}

assert {
  condition = contains(keys(resource.aws_ecs_cluster.hello_cluster), "name")
  error_message = "ECS Cluster not found"
}
```

---

## ☁️ S3 Bucket Configuration
- Encrypted with AES-256
- Versioning enabled
- Public access fully blocked

---

## 🧹 Teardown
```bash
terraform destroy -auto-approve
```

---

terraform-ecs-hello-world/
├── main.tf
├── variables.tf      
├── outputs.tf 
├── modules/
├── tests/              
└── README.md


