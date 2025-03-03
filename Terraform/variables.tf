variable "repository_name" {
  type    = string
  default = "automations"
}

variable "bucket_name" {
  type    = string
  default = "yosefi-terraform-bucket"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "wake-up-streamlit"
}

variable "awslogs_group" {
  type    = string
  default = "/ecs/wakeup-streamlit-task"
}

variable "container_image" {
  type    = string
  default = "340752809566.dkr.ecr.us-east-1.amazonaws.com/automations:latest"
}

variable "logs_retention_in_days" {
  type    = number
  default = 90
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-082c577e09acd6db4", "subnet-0aef073da1be2a3fa"]
}

variable "security_group_id" {
  type    = list(string)
  default = ["sg-0f91733c2865a3aea"]
}

variable "wakeup_streamlit_scheduler" {
  type    = string
  default = "wakeup_streamlit_scheduler"
}
