data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_iam_role" "scheduler_role" {
  name = "ecsEventsRole"
}

resource "aws_ecr_repository" "automations" {
  name                 = var.repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "repository_lifecycle_police" {
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

resource "aws_ecs_cluster" "wake_up_streamlit" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "wakeup_task" {
  family                   = var.cluster_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "wakeup"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.wakeup_streamlit_task.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
          mode                  = "non-blocking"
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

resource "aws_cloudwatch_log_group" "wakeup_streamlit_task" {
  name              = var.awslogs_group
  retention_in_days = var.logs_retention_in_days
}

resource "aws_scheduler_schedule" "wakeup_streamlit_scheduler" {
  name       = var.wakeup_streamlit_scheduler
  group_name = "default"

  flexible_time_window {
    mode = "OFF"
  }

  schedule_expression          = "cron(0 8 * * ? *)"
  schedule_expression_timezone = "Asia/Jerusalem"

  target {
    arn      = aws_ecs_cluster.wake_up_streamlit.arn
    role_arn = data.aws_iam_role.scheduler_role.arn

    ecs_parameters {
      task_definition_arn = aws_ecs_task_definition.wakeup_task.arn_without_revision
      launch_type         = "FARGATE"

      network_configuration {
        assign_public_ip = true
        subnets          = var.subnet_ids
        security_groups  = var.security_group_id
      }
    }
  }
}

output "repository_url" {
  value = aws_ecr_repository.automations.repository_url
}

output "awslogs_group" {
  value = aws_cloudwatch_log_group.wakeup_streamlit_task.name
}

