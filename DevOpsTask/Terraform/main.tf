terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 4.67" }
  }
}

provider "aws" {
  region = var.aws_region
}

# 1) VPC
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
}

# 2) ALB + Target Groups + Listeners
module "alb" {
  source            = "./modules/alb"
  name              = "${var.app_name}-alb"
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids
  frontend_port     = var.frontend_port
  backend_port      = var.backend_port
  api_path_pattern  = "/api*"
}

# 3) ECS Cluster
module "ecs_cluster" {
  source = "./modules/ecs_cluster"
  name = var.cluster_name
}

# 4) Backend Service
module "backend" {
  source            = "./modules/ecs_service"
  name              = "${var.app_name}-backend"
  cluster_id        = module.ecs_cluster.cluster_id
  container_image   = var.backend_image
  container_port    = var.backend_port
  desired_count     = var.backend_count
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_ids = [module.alb.alb_security_group_id]
  target_group_arn = module.alb.backend_tg_arn
  #vpc_id = module.vpc.vpc_id
}

# 5) Frontend Service
module "frontend" {
  source            = "./modules/ecs_service"
  name              = "${var.app_name}-frontend"
  cluster_id        = module.ecs_cluster.cluster_id
  container_image   = var.frontend_image
  container_port    = var.frontend_port
  desired_count     = var.frontend_count
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_ids = [module.alb.alb_security_group_id]
  target_group_arn = module.alb.frontend_tg_arn
  #vpc_id = module.vpc.vpc_id
}

# # 6) Listener & Rules on ALB
# resource "aws_lb_listener" "frontend" {
#   load_balancer_arn = module.alb.alb_arn
#   port              = 80
#   protocol          = "HTTP"
#   default_action {
#     type             = "forward"
#     target_group_arn = module.frontend.target_group_arn
#   }
# }

# resource "aws_lb_listener_rule" "backend_api" {
#   listener_arn = aws_lb_listener.frontend.arn
#   priority     = 100
#   action {
#     type             = "forward"
#     target_group_arn = module.backend.target_group_arn
#   }
#   condition {
#     path_pattern {
#       values = ["/api*"]
#     }
#   }
# }
