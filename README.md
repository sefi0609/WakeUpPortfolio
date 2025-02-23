# **Wakeup My Streamlit app**
Streamlit apps automatically go to sleep after 24 hours of inactivity.  
To keep my app awake and responsive, I’ve implemented a Python script that pings the app daily.  
## **How It Works**
- A lightweight Alpine-based Docker container runs the script to ensure minimal resource usage and independence from the host OS.
- The container is deployed on AWS ECS and scheduled to run daily at 08:00.
- This setup ensures my Streamlit app stays active without manual intervention.

## **Docker Container**
The container is built using the following Dockerfile:  
👉 [View the Dockerfile](Dockerfile)

## **Infrastructure**
The Terraform configuration to provision the necessary infrastructure is available here:  
👉 [Terraform folder](Terraform)