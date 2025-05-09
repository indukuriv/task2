variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "azs" {
  type    = list(string)
  default = ["us-east-1a","us-east-1b","us-east-1c"]
}
variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
}

variable "cluster_name" {
  default = "lf-cluster"
}
variable "app_name" {
  default = "lightfeather"
}

variable "backend_image" {
  description = "ECR URI for backend" 
}
variable "backend_port" {
  default = 8080
}
variable "backend_count" {
  default = 2
}

variable "frontend_image" {
  description = "ECR URI for frontend"
}
variable "frontend_port" {
  default = 3000
}
variable "frontend_count" {
  default = 2
}
