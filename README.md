## Wakeup My Streamlit app
Streamlit apps automatically go to sleep after 24 hours of inactivity. To ensure my app stays awake, I’ve created a Python script that pings the app daily.  
### How It Works
- The script runs inside a lightweight Alpine-based Docker container to remain independent of the host OS.
- The container is deployed on AWS ECS and is scheduled to run daily at 08:00.
- This setup ensures the app remains responsive without manual intervention.

### Dockerfile
The container is built using the following Dockerfile:
[View the Dockerfile](Dockerfile)
