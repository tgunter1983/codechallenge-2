# --- ECS Cluster ---
resource "aws_ecs_cluster" "hello_cluster" {
  name = "${var.project_name}-cluster"
}

# --- IAM Role for ECS Task ---
resource "aws_iam_role" "ecs_task_exec" {
  name = "${var.project_name}-ecsTaskExecutionRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_exec_policy" {
  role       = aws_iam_role.ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# --- Task Definition ---
resource "aws_ecs_task_definition" "hello_task" {
  family                   = "${var.project_name}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn

  container_definitions = jsonencode([
    {
      name      = "hello"
      image     = "nginxdemos/hello"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.project_name
        }
      }
    }
  ])
}

# --- ECS Service ---
resource "aws_ecs_service" "hello_service" {
  name            = "${var.project_name}-service"
  cluster         = aws_ecs_cluster.hello_cluster.id
  task_definition = aws_ecs_task_definition.hello_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }
}

# --- Outputs ---
output "cluster_name" {
  description = "ECS Cluster name"
  value       = aws_ecs_cluster.hello_cluster.name
}

output "service_name" {
  description = "ECS Service name"
  value       = aws_ecs_service.hello_service.name
}
