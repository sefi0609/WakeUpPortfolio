variable "repository_name" {
  type    = string
  default = "automations"
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
  default = "wake-up-streamlit-task-group"
}