resource "aws_ecr_repository" "automations" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "repository-lifecycle-police" {
  repository = aws_ecr_repository.automations.name

  policy = jsonencode(
    {
      rules = [
        {
          rulePriority = 1
          description  = "Expire images older than 3 days"
          selection = {
            tagStatus   = "untagged"
            countType   = "sinceImagePushed"
            countUnit   = "days"
            countNumber = 3
          }
          action = {
            type = "expire"
          }
        }
      ]
    }
  )
}

resource "aws_ecs_cluster" "wake-up-streamlit" {
  name = "wake-up-streamlit"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = "wakeup-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::340752809566:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name      = "wakeup"
      image     = "340752809566.dkr.ecr.us-east-1.amazonaws.com/automations:latest"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

output "repository_url" {
  value = aws_ecr_repository.automations.repository_url
}
