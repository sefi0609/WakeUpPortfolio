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
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "service" {
  family                   = var.cluster_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::340752809566:role/ecsTaskExecutionRole"
  container_definitions = jsonencode([
    {
      name      = "wakeup"
      image     = "340752809566.dkr.ecr.us-east-1.amazonaws.com/automations:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.awslogs_group,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "ecs",
          awslogs-create-group  = "true",
          mode                  = "non-blocking",
          max-buffer-size       = "25m"
        }
      }
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
