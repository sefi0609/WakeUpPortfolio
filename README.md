# **Wakeup My Streamlit app**
Streamlit apps automatically go to sleep after 24 hours of inactivity.  
To keep my app awake and responsive, I’ve implemented a Python script that checks its status and wakes it up if necessary.  

## **How It Works**
- A lightweight **Alpine-based Docker container** runs the script to ensure minimal resource usage and independence from the host OS.
- The script **uses Selenium** to check if the app is running.
- If the app is not active, Selenium **clicks the wakeup button** to restart it.
- The container is **deployed on AWS ECS** and scheduled to run daily at **08:00** using **AWS EventBridge**.
- This setup ensures the app stays active **without manual intervention**.

## **Docker Container**
- Uses **Alpine Linux** for a minimal footprint.
- Installs required dependencies, including **Selenium** and a headless browser.
- Runs a **Python script** that automates the wakeup process.

The container is built using the following Dockerfile:  
👉 [View the Dockerfile](Dockerfile)

## **Infrastructure**
The **Terraform** folder contains the infrastructure as code (IaC) setup to deploy the container on AWS.

| File                                                 | Description                                                                                                                                         |
|------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------|
| [backend.tf](Terraform/backend.tf)                   | Configure the Terraform **remote state file** using AWS S3                                                                                          |
| [s3.tf](Terraform/s3.tf)                             | Provision an **S3 bucket** to store the Terraform state file                                                                                        |
| [s3_permissions.json](Terraform/s3_permissions.json) | Defines the **bucket policy** for securing Terraform state storage                                                                                  |
| [providers.tf](Terraform/providers.tf)               | Configures **Terraform providers** (AWS, etc.)                                                                                                      |
| [main.tf](Terraform/main.tf)                         | Sets up an **ECR repository**, provisions the **ECS cluster**, defines the **task**, configures the **scheduler**, and sends logs to **CloudWatch** |

### **Prerequisites for Deployment**
- **AWS credentials** must be configured for Terraform.

### **Deployment Steps**
1. **Build the Docker image:**
```sh
docker build -t wakeup-streamlit .
```
2. **Push the image to AWS ECR**:
```sh
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <your-ecr-repo-url>
docker tag wakeup-streamlit <your-ecr-repo-url>:latest
docker push <your-ecr-repo-url>:latest
```
3. **Deploy the infrastructure with Terraform:**
```sh
cd Terraform  
terraform init  
terraform apply  
```